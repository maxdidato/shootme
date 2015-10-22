module Shootme
  module Adapter
    class << self

      def use(adapter)
        @adapter = adapter
      end

      def current_adapter
        @adapter || default_adapter
      end

      def default_adapter
        Shootme::Drivers::Browserstack
      end
    end
  end
end