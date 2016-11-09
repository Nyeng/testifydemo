require "net/http"
require "uri"
require 'typhoeus'
include PageObjects

module PageObjects
  class ClientLogin
    include Capybara::RSpecMatchers
    include NrkHeadless

    def initialize(client_name: "Bjarne")
      puts Capybara.app_host
      @config = NrkIdUtils::Config.new(get_config_filepath)
      unless ENV['USER'] == 'sn07028'
        go_headless
      end
      Capybara.app_host = @config.data['idserver']
      @client_name = client_name
      ##Clean start
      visit Capybara.app_host + '/core/logout'


      puts "Testing on environment: #{ENV['ENVIRONMENT']}"
    end

    def get_activation_code
      base_url = Capybara.app_host + "/core/registrer/enhet"
      puts "running Typhoeus request"
      request_parameters = {
          method: 'get',
          followlocation: true,
          cookiejar: "cookies/#{ENV['ENVIRONMENT']}/#{@client_name}.txt",
          cookiefile: "cookies/#{ENV['ENVIRONMENT']}/#{@client_name}.txt",
          connecttimeout: 20,
          headers: {
              Accept: 'application/json',
              Authorization: "Basic dHYubnJrLm5vLmJhbmFuYXR2OnRoYXRWYWx1ZQ==" #@bearer_token
          },
          params: {:client_id => "tv.nrk.no.bananatv", :scope=> "openid profile psapi-userdata offline_access"}
      }
      puts "Getting activation code"

      run_typhoeus_request(base_url,request_method:'get', options:request_parameters,parse_json:true)
      activation_code = @single_request_data[:activationCode]
      nrkcsrf = @single_request_data[:headers][:nrkcsrf]

      puts activation_code

      return activation_code,nrkcsrf
    end

    def poll_activation_code(activation_code, nrkcsrf, poll_wait:0)
      base_url = Capybara.app_host + "/core/registrer/enhet"

      request_paramters = {
          method: 'post',
          followlocation: true,
          connecttimeout: 20,
          cookiejar: "cookies/#{ENV['ENVIRONMENT']}/#{@client_name}.txt",
          cookiefile: "cookies/#{ENV['ENVIRONMENT']}/#{@client_name}.txt",
          headers: {
              Accept: 'application/json',
              Authorization: "Bearer dHYubnJrLm5vLmJhbmFuYXR2OnRoYXRWYWx1ZQ==",
              nrkcsrf:nrkcsrf},
          params: {:client_id => "tv.nrk.no.bananatv", :scope=> "openid profile psapi-userdata offline_access"},
          body: {:activationCode => activation_code}
      }
      sleep poll_wait
      run_typhoeus_request(base_url,request_method:'post', options:request_paramters)
      @code = @single_request_data[:code]
    end

    def parse_json string
      JSON.parse(string,symbolize_names:true)
    end
    #
    def validata_activation_code code
      puts "This is the code you need to validate: #{code}"
      if code.length > 5 or code =~ /\d/
        puts "Code is #{code}"
        failure("Verification code can't be longer than 5 characters and should not contain any letters")
      end
    end

    def exchange_code_for_token
      endpoint = Capybara.app_host + '/core/connect/token'
      puts "Posting to #{endpoint}"
      request_paramters = {
          method: 'post',
          followlocation: true,
          connecttimeout: 20,
          cookiejar: "cookies/#{ENV['ENVIRONMENT']}/#{@client_name}.txt",
          cookiefile: "cookies/#{ENV['ENVIRONMENT']}/#{@client_name}.txt",
          headers: {
              #Content-Type: 'application/x-www-form-urlencoded',
              'Content-Type'=> "application/x-www-form-urlencoded",
              Accept: 'application/json',
              Authorization: "Basic dHYubnJrLm5vLmJhbmFuYXR2OnRoYXRWYWx1ZQ=="
          },
          body: {:scope=> "openid profile psapi-userdata offline_access",
                 :code => @code, :grant_type => "device_code"}
      }
      run_typhoeus_request(endpoint,request_method:'post',options: request_paramters)
      access_token = @single_request_data[:access_token]
      refresh_token = @single_request_data[:refresh_token]
      return access_token, refresh_token
    end

    def run_typhoeus_request(*api_requests,request_method:'get', options:{},parse_json:true)
      hydra = Typhoeus::Hydra.new(max_concurrency:200)
      api_requests.each do|endpoint|
        @response_data = []
        request = Typhoeus::Request.new(endpoint,options)
        request.on_complete do|response|
          response_data = response.body
          response_data.force_encoding('UTF-8')
          @response_code = response.code

          if response.code.between?(399,512)
            puts "Status code is #{response.code}"
            puts "Response return message #{response.return_message}"
            puts "The attempted request was: #{endpoint} with request method: #{request_method}"

            failure("Unacceptable response code #{response.code}, check your request body: The attempted request was: #{endpoint} with request method: #{request_method} ")
          elsif response.timed_out?
            puts "Response timed out: Attempted request was: #{endpoint}"
          elsif response.code == 0
            puts "Could not get a response message for attempted request #{endpoint}"
          else
            puts "Response code: #{response.code}"
            if request_method.eql?'post'
              @single_request_data = parse_json(response.body) unless !parse_json or response.code == 202
            end
          end
          begin
            if request_method.eql?'get'
              @single_request_data = parse_json(response.body)
            end
          rescue JSON::ParserError => e
            puts e.message
            puts "Failed parsing Json"
            puts response.body
          end
        end
        hydra.queue(request)
      end
      hydra.run
    end

    def validate_polling_response_code response_code
      unless response_code.to_i.eql?@response_code
        failure("Response code is not #{response_code}, it's #{@response_code}")
      end
    end

    def activate_client activation_code
      #Login user regular way first
      visit '/'
      fill_in 'login-id', :with => 'nett-tv-test@nrk.no'
      fill_in 'login-pwd', :with => 'hanstore'
      click_button('login-submit')
      # login-submit
      visit '/aktiver'
      fill_in 'Code', :with => activation_code
      puts "Attempting to activate client.."
      find(:xpath,'/html/body/div[1]/div[1]/div[1]/form/div[2]/div[2]/button').click
    end

    def validate_activation_text
      #failure('Text is not Enheten er aktivert') unless page.find('div.margin-m-tb').text.eql?'Enheten er aktivert :)'
    end

    def get_user_data(access_token:'dsdfgsdfssffsfe')
      endpoint = Capybara.app_host + '/core/connect/userInfo'
      request_paramters = {
          method: 'get',
          followlocation: true,
          connecttimeout: 20,
          headers: {
              Accept: 'application/json',
              Authorization: "Bearer #{access_token}"
          },
      }
      run_typhoeus_request(endpoint,request_method:'get',options:request_paramters)
      puts "Receiving these values with token: "
      user_Id = @single_request_data[:sub]
      name = @single_request_data[:name]
      given_name = @single_request_data[:given_name]
      family_name = @single_request_data[:family_name]

      puts "User id: #{user_Id}\n
      Name: #{name}  \n
      Given name: #{given_name} \n
      Family name: #{family_name}"
    end

    def logout(refresh_token: "asdasd")
      endpoint = Capybara.app_host + '/core/connect/revocation'
      request_paramters = {
          method: 'post',
          followlocation: true,
          connecttimeout: 20,
          headers: {
              Authorization: "Basic dHYubnJrLm5vLmJhbmFuYXR2OnRoYXRWYWx1ZQ==",
              'Content-Type'=> "application/x-www-form-urlencoded",
              Accept: 'application/json'
          },
          body: { :token_type_hint => "refresh_token",
                  :token => refresh_token}
      }
      run_typhoeus_request(endpoint,request_method:'post',options:request_paramters,parse_json:false)
    end

  end
end
