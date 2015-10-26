module Shootme
  module Drivers
    class Browserstack

      def self.set_driver opts,credentials
        caps = Selenium::WebDriver::Remote::Capabilities.new
        caps['browserstack.tunnel'] = 'true'
        caps['browserstack.selenium_version'] = '2.47.1'
        caps['browserstack.ie.driver'] = '2.47'
        name = "shootme#{rand(9999)}".to_sym
        Capybara.register_driver name do |app|
          Capybara::Selenium::Driver.new(app,
                                         {:url => "http://#{credentials[:username]}:#{credentials[:password]}@hub.browserstack.com/wd/hub",
                                          :browser => :remote,
                                          :desired_capabilities => caps.merge!(opts)})
        end
        name
      end
    end
  end
end