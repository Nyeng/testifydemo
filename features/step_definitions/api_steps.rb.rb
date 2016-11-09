include PageObjects

When(/^at jeg skal teste client login med klienten (.*)$/) do |client|
  @clientlogin = ClientLogin.new(client_name: client)
end

When(/^jeg kaller engangskode for klienten$/) do
  @activation_code,@nrkcsrf = @clientlogin.get_activation_code
end

When(/^skal jeg få generert opp en engangskode uten tall$/) do
  @clientlogin.validata_activation_code(@activation_code)
end

When(/^jeg aktiverer engangskoden$/) do
  @clientlogin.activate_client(@activation_code)
end

When(/^jeg poller aktiveringskoden etter (\d+) sekunder$/) do |seconds|
  @clientlogin.poll_activation_code(@activation_code, @nrkcsrf, poll_wait:seconds.to_i)
end

When(/^skal jeg få responskode (\d+)/) do |arg|
  @clientlogin.validate_polling_response_code(arg)
  #@clientlogin.poll_activation_code(@activation_code, @nrkcsrf)
end

When(/^skal jeg få beskjed om at enheten er aktivert$/) do
  @clientlogin.validate_activation_text
end

When(/^jeg gjennomfører login for å hente ut access token$/) do
  @activation_code,@nrkcsrf = @clientlogin.get_activation_code
  @clientlogin.validata_activation_code(@activation_code)
  @clientlogin.activate_client(@activation_code)
  @clientlogin.poll_activation_code(@activation_code, @nrkcsrf)
  @access_token,@refresh_token = @clientlogin.exchange_code_for_token
end

When(/^skal jeg kunne hente ut access token$/) do
  @access_token = @clientlogin.exchange_code_for_token
end

When(/^at jeg poller aktiveringskoden for å hente ut en kode$/) do
  @clientlogin.poll_activation_code(@activation_code, @nrkcsrf)
end

When(/^skal jeg få hentet ut brukerdataen min$/) do
  @clientlogin.get_user_data(access_token: @access_token)
end

When(/^jeg prøver å logge ut med refresh token$/) do
  @clientlogin.logout(refresh_token:@refresh_token)
end