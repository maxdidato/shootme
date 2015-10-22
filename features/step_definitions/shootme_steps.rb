Given(/^I go on (.*)$/) do |url|
  Capybara.current_session.visit(url)
end

Then(/^I should see the simple web app hit by the following browsers$/) do |browsers|
  browsers.raw.map { |el| el[0] }.each do |browser|
    expect(SimpleWebApp.user_agents.any? { |br| br.include?(browser) }).to be_truthy
  end
end
Given(/^I hit the simple web app$/) do
  Capybara.current_session.visit("http://localhost:#{SimpleWebApp.port}/")
end

Then(/^the screenshot '(.*)' should include the text '(.*)'/) do |screenshot, text|
  expect(RTesseract.new(screenshot).to_s).to include(text)

end

Given(/^I performed a tunnel to browserstack$/) do
  Sys::ProcTable.ps{ |proc|
    Process.kill('KILL',proc.pid) if proc.to_s.downcase.include?('browserstack')
  }
  os = OS.mac? ? 'mac' : 'linux'
  process = ChildProcess.build("#{File.expand_path('../../../', __FILE__)}/tools/browserstack/#{os}/BrowserStackLocal", '4uya9z4zNHXwxUsh9JcX', '-force')
  a = Tempfile.new("child-output")
  process.io.stdout= a
  process.start
  WaitUtil.wait_for_condition("Browserstack tunnel started", :timeout_sec => 5, :delay_sec => 0.1) do
    a.open.read.include?('You can now access your local server')
  end
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
  rescue SystemExit => ex
    @exit_status =ex.status
  end
  file.unlink
end


Then(/^I should see '(.*)'$/) do |text|
  expect(page.html).to include(text)
end

Given(/^a simple application showing the user agent is running$/) do
  SimpleWebApp.serve
end


Given(/^a web app which make test failing using '(.*)' is running$/) do |failing_browser|
  SimpleWebApp.serve(failing_browser)
end

Then(/^the scenario should fail$/) do
  expect(@exit_status).not_to eq(0)
end