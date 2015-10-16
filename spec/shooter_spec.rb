require 'spec_helper'

describe Shootme::Shooter do
    context '#initialize' do

      it 'accepts the credentials for Browserstack account' do
        shooter = Shootme::Shooter.new(username:'username',password:'password')
        expect(shooter.credentials[:username]).to eq('username')
        expect(shooter.credentials[:password]).to eq('password')
      end


    end


  end
