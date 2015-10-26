$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'capybara'
require 'shootme'

shared_context :simple_app do
  include Rack::Test::Methods
  require 'test_app'
  Capybara.app = Sinatra::Application
end