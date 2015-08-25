require 'childprocess'
require 'rtesseract'
require 'waitutil'

Given(/^I go on (.*)$/) do |url|
  Capybara.current_session.visit(url)
end

Then(/^I should see a screenshot including (.*)/) do |text|
  # t = Thread.new{
  # pid = Process.fork{
  #    while(!File.exists?("/Users/mdidato/Projects/Personal/shootme/lib/Take a screenshot/ie_7.0.jpg")); end
  # }
  # Process.wait pid
  # expect(RTesseract.new("/Users/mdidato/Projects/Personal/shootme/lib/Take a screenshot/ie_7.0.jpg").to_s).to include(text)

  # WaitUtil.wait_for_condition("my_event to happen", :timeout_sec => 100, :delay_sec => 0.5) do
  #    File.exists?("/Users/mdidato/Projects/Personal/shootme/lib/Take a screenshot/ie_7.0.jpg")
  #  end
  #  expect(RTesseract.new("/Users/mdidato/Projects/Personal/shootme/lib/Take a screenshot/ie_7.0.jpg").to_s).to include(text)

end

Given(/^I performed a tunnel to browserstack$/) do
  process = ChildProcess.build("#{File.expand_path('../../../', __FILE__)}/tools/BrowserStackLocal", "scQH4sZwU3TYhWygmvpp")
  process.io.inherit!
  process.start
end

And(/^I have the following configuration$/) do |text|
  data = YAML.load_file("/Users/mdidato/Projects/Personal/shootme/.shootme.yml")
  data['browsers']=YAML.load(text)['browsers']
  File.open("/Users/mdidato/Projects/Personal/shootme/.shootme.yml", 'w') { |f| YAML.dump(data, f) }
end

When(/^I execute this scenario$/) do |text|
  file = Tempfile.new(['hello', '.feature'],'/Users/mdidato/Projects/Personal/shootme/features')
  file.write(text)
  file.close
  # process = ChildProcess.build("cucumber","--require", "features", file.path)
  # process.io.inherit!
  # process.start
  puts `cucumber --require features #{file.path}`
  # file.unlink
end