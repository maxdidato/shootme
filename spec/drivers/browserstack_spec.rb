require 'spec_helper'


describe Shootme::Drivers::Browserstack do

  let(:opts){{option1:'value',option2:'value'}}
  let(:credentials){{username:'user',password:'password'}}

  it 'generates a random driver name and set it in capybara' do
    driver_name= described_class.set_driver(opts,credentials)
    driver = Capybara.drivers[driver_name].call
    expect(driver.options[:url]).to eq("http://#{credentials[:username]}:#{credentials[:password]}@hub.browserstack.com/wd/hub")
    expect(driver.options[:desired_capabilities]).to include(opts)
  end

end