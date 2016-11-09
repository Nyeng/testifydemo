Given /^I am on (.*)$/ do |url|
  visit url
end

When(/^at vi har en testbruker "([^"]*)"$/) do |username|
  puts "Username is #{username}"
  @username = username
  @password = "nrktestpassord"
end

When(/^(?:at )?vi går mot testsiden "([^"]*)"$/) do |testsite|
  Capybara.app_host = testsite
end

Then(/^skal vi være utlogget fra innloggingstjenesten$/) do
  visit '/profil/loggut'
  page.visit '/core/connect/endsession'
end

When(/^jeg går til profil-siden$/) do
  visit '/profil/rediger'
end

When(/^at jeg er på innloggingssiden$/) do
  visit ''
end

When(/^(?:at )?jeg logger inn$/) do
  sleep 3
  login
end


When(/^brukeren fullfører en innlogging mot identitetstjenesten$/) do
  login
end

When(/^skal jeg kunne motta følgende profildata om brukeren$/) do |table|
  verify_page_contains_fields(table: table.raw)
end

When(/^at jeg er på innloggingssiden for første gang på en stund$/) do
  select_dement_user
  sleep 5
end

When(/^skal brukeren ikke få en varsling om antall forsøk tilgjengelig før utestenging$/) do
  verify_remaining_attempts(@attempts)
end

When(/^jeg har fylt ut feil passord i "Passord"\-feltet (\d*) ganger$/) do |times|
  @attempts = times.to_i
  enter_wrong_password_for_a_user_a_number_of_times(number: @attempts)
end

def verify_remaining_attempts(i)
  # checking that, the user get's info on how many attempts there is left.
  # when 3 < i < 11; verify text: "har (11-i) forsøk igjen
  sleep 5
  if i>3 and i<11
    page.assert_text("Du har #{11-i} forsøk igjen før kontoen din blir låst i 15 min.")
  end
end

def enter_wrong_password_for_a_user_a_number_of_times(number: 4)
  puts "INFO entering wrong password #{number} times"
  number.times.each do |i|
    #puts "INFO login attempt no #{i}."
    @password = "tullepassord#{i+1}"
    login
    sleep 3
  end
end

def select_dement_user
  @username = 'vegard.nyeng@nrk.no'
  @password = 'TullePASSORD'
end

def login
  fill_in 'userName', :with => @username
  fill_in 'password', :with => @password
  click_button('login-submit')
  puts "Logging in user..."
  sleep 3
end

def failure(msg, prefix='')
  puts 'FAILURE'
  puts msg
  prefix = prefix + '_' if prefix.length > 0
  puts 'save screenshot'
  #time_stamp = DateTime.now.strftime(%"%H:%M")
  save_screenshot("screenshots/#{prefix}#.png")
  puts 'call fail'
  fail msg
end

When(/^skal jeg kunne endre følgende felter$/) do |table|
  sleep 2
  data = table.raw
  fields = data.map { |element| element[0] }
  fields.each do |element|
    find_field element
    fill_in element, :with => '2323'
  end
  sleep 2
end

When(/^jeg setter skjermstørrelsen til (.*) og (.*)$/) do |width, height|
  page.driver.browser.manage.window.resize_to(width, height)
  sleep 2
end

When(/^jeg navigerer til undersiden "([^"]*)"$/) do |homepage|
  visit homepage
end

When(/^skal jeg kunne klikke på (.*)$/) do |link_text|
  begin
    click_link(link_text)
  rescue
    failure("Fant ikke linken du lette etter","#{Time.now.to_i}.png")
  end
  sleep 5
end