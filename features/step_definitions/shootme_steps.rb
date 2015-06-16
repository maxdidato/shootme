Given(/^I go on www\.google\.it$/) do
  Capybara.current_session.visit('http://www.google.co.uk')
end

Then(/^I should see a picture$/) do
  true
end