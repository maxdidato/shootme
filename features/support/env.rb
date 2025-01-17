require 'capybara'
require 'sys/proctable'
require 'os'
require 'childprocess'
require 'rtesseract'
require 'waitutil'
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
# PROJECT_DIR = File.expand_path('../', __FILE__)
require 'shootme'
require 'shootme/shooter'

Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, :browser => :chrome)
end
Capybara.current_driver =:selenium
# Capybara.javascript_driver = :chrome
include Capybara::DSL
include Shootme