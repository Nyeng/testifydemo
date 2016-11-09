When /^I fill in "([^\"]*)" found by "([^\"]*)" with "([^\"]*)"$/ do |value, type, keys|
  puts ENV['BROWSERSTACK']
  fill_in(value, :with => keys)
end
 
When /^Jeg søker$/ do
  find_field('q').native.send_key(:enter)
end
 
Then /^I should see title "([^\"]*)"$/ do |title|
  expect(page).to have_title title
end



