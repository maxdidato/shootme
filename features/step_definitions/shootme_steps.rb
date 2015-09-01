require 'childprocess'
require 'rtesseract'
require 'waitutil'

Given(/^I go on (.*)$/) do |url|
  Capybara.current_session.visit(url)
end

Then(/^the screenshot '(.*)' should include the text '(.*)'/) do |screenshot,text|
  expect(RTesseract.new(screenshot).to_s).to include(text)

end

Given(/^I performed a tunnel to browserstack$/) do
  process = ChildProcess.build("#{File.expand_path('../../../', __FILE__)}/tools/BrowserStackLocal", "scQH4sZwU3TYhWygmvpp")
  process.io.inherit!
  process.start
end

And(/^I have the following configuration$/) do |text|
  File.open("/Users/mdidato/Projects/Personal/shootme/.shootme.yml", 'w') { |f| f.write(YAML.load(text).to_yaml) }
end

When(/^I execute this scenario$/) do |text|
  file = Tempfile.new(['hello', '.feature'],'/Users/mdidato/Projects/Personal/shootme/features')
  file.write(text)
  file.close
puts  `cucumber --require features #{file.path}`
  file.unlink
end