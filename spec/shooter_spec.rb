require 'spec_helper'
require 'test_app'
require 'rack/test'


describe Shootme::Shooter do
  let(:credentials) { {username: 'username', password: 'password'} }
  subject{Shootme::Shooter.new(credentials)}
  include_context :simple_app


  context '#initialize' do

    it 'accepts the credentials for Browserstack account' do
      shooter = Shootme::Shooter.new(credentials)
      expect(shooter.credentials).to eq(credentials)
    end

  end

  context '#save_browser_state' do

    it 'returns current url and cookies of the cayabaras current session' do
      Capybara.visit('/another_url')
      Capybara.current_session.driver.execute_script "document.cookie=\“cookie_name=cookie_value; path=/\";"
    end

  end


end
