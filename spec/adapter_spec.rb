require 'spec_helper'

describe Shootme::Adapter do
  it 'sets the default adapter as BrowserStack' do
    expect(described_class.default_adapter).to eq(Shootme::Drivers::Browserstack)
  end

  context '.current_adapter' do

    it 'returns the default adapter if none have been set' do
      expect(described_class.current_adapter).to eq(Shootme::Drivers::Browserstack)
    end

    it 'returns whatever is explicitly set' do
      driver = double(:driver)
      described_class.use driver
      expect(described_class.current_adapter).to eq(driver)
    end

  end


end