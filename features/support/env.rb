require 'capybara'
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'shootme'
require 'shootme/shooter'

Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, :browser => :chrome)
end
Capybara.current_driver =:chrome
# Capybara.javascript_driver = :chrome
include Shootme