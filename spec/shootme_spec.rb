require 'spec_helper'

describe Shootme do

  context 'when included' do

    let!(:rb_language) do
      rb_language = Cucumber::RbSupport::RbLanguage.new(double(:runtime))
      Cucumber::RbSupport::RbDsl.rb_language = rb_language
      rb_language
    end

    before do
      Class.include(Shootme)
    end

    it 'adds the an around hook to Cucumber for the @screenshot tag' do
      rb_language.send(:hooks)
      expect(rb_language.send(:hooks)[:around].any? { |hook| hook.tag_expressions.include?('@screenshot') }).to be_truthy
    end

    it 'adds the an around hook to Cucumber for the @multibrowser tag' do
      expect(rb_language.send(:hooks)[:around].any? { |hook| hook.tag_expressions.include?('@multibrowser') }).to be_truthy
    end

  end


end