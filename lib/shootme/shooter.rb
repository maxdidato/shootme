require 'selenium-webdriver'
module Shootme

  class Shooter

    attr_reader :credentials

    def initialize(username:,password:)
      @credentials = {username: username, password:password}
    end

    def save_browser_state
      cookies = Capybara.current_session.driver.browser.manage.all_cookies
      url = Capybara.current_session.current_url
      return cookies, url
    end

    def restore_cookies(cookies,url)
      Capybara.current_session.visit(url)
      cookies.each do |cookie|
        Capybara.current_session.driver.execute_script "document.cookie=\“#{cookie[:name]}=#{cookie[:value]}; path=/\";"
      end
    end

    def take_screenshot(url, screenshot_name)
      Capybara.current_session.visit(url)
      Capybara.current_session.save_screenshot("#{screenshot_name}.jpg")
    end

    def perform_screenshooting browser_settings
      driver_name = Shootme::Adapter.current_adapter.set_driver browser_settings,credentials
      cookies, url = save_browser_state
      Capybara.using_driver driver_name do
        restore_cookies(cookies,url)
        screenshot_name = "#{browser_settings[:browser].to_s.downcase}_#{browser_settings[:browser_version].to_s.downcase}"
        take_screenshot(url, screenshot_name)
      end
    end
  end
end