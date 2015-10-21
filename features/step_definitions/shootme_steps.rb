require 'childprocess'
require 'rtesseract'
require 'waitutil'

Given(/^I go on (.*)$/) do |url|
  Capybara.current_session.visit(url)
end

Then(/^I should see the simple web app hit by all the browsers$/) do
  SimpleWebApp.user_agents
end
Given(/^I hit the simple web app$/) do
  Capybara.current_session.visit("http://localhost:#{SimpleWebApp.port}/")
end

Then(/^the screenshot '(.*)' should include the text '(.*)'/) do |screenshot, text|
  expect(RTesseract.new(screenshot).to_s).to include(text)

end

Given(/^I performed a tunnel to browserstack$/) do
  process = ChildProcess.build("#{File.expand_path('../../../', __FILE__)}/tools/browserstack/mac/BrowserStackLocal", '4uya9z4zNHXwxUsh9JcX', '-force')
  process.io.inherit!
  process.start
end

And(/^I have the following configuration$/) do |text|
  File.open("/Users/mdidato/Projects/Personal/shootme/.shootme.yml", 'w') { |f| f.write(YAML.load(text).to_yaml) }
end

When(/^I execute this scenario$/) do |text|
  file = Tempfile.new(['hello', '.feature'], '/Users/mdidato/Projects/Personal/shootme/features')
  file.write(text)
  file.close
  begin
    Cucumber::Cli::Main.execute(['-r', 'features', file.path])
  rescue SystemExit
  end
  file.unlink
end


Then(/^I should see '(.*)'$/) do |text|
  expect(page.html).to include(text)
end

Given(/^a simple application showing the user agent is running$/) do
  th = Thread.new{SimpleWebApp.serve}
end

