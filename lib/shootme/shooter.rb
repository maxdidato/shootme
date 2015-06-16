module Shootme
  class Shooter

    def self.credentials credentials=nil
      @credentials = credentials if credentials
      @credentials
    end

    def save_browser_state
      cookies = Capybara.current_session.driver.browser.manage.all_cookies
      url = Capybara.current_session.current_url
      return cookies, url
    end

    def restore_cookies(cookies)
      Capybara.current_session.visit('http://localhost:7001/')
      browser = Capybara.current_session.driver.browser
      cookies.each do |cookie|
        browser.manage.add_cookie :name => cookie[:name], :value => cookie[:value]
      end
    end

    def take_screenshot(url, screenshot_name)
      Capybara.current_session.visit(url)
      Capybara.current_session.save_screenshot("#{screenshot_name}.jpg")
    end

    def set_driver opts
      caps = Selenium::WebDriver::Remote::Capabilities.new
      caps['browserstack.tunnel'] = 'true'
      name = "shootme#{rand(9999)}".to_sym
      Capybara.register_driver name do |app|
        Capybara::Selenium::Driver.new(app,
                                       {:url => "http://#{self.class.credentials[:username]}:#{self.class.credentials[:password]}@hub.browserstack.com/wd/hub",
                                        :browser => :remote,
                                        :desired_capabilities => caps.merge!(opts)})
      end
      name
    end

    def perform_screenshooting browser_settings
      driver_name = set_driver browser_settings
      cookies, url = save_browser_state
      Capybara.using_driver driver_name do
        restore_cookies(cookies)
        screenshot_name = "#{browser_settings[:browser].downcase}_#{browser_settings[:browser_version].downcase}"
        take_screenshot(url, screenshot_name)
      end
    end
  end
end