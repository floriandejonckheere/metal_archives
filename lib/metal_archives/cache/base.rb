# frozen_string_literal: true

module MetalArchives
  module Cache
    ##
    # Generic cache interface
    #
    class Base
      attr_accessor :options

      def initialize(options = {})
        @options = options

        validate!
      end

      def validate!; end

      def []
        raise NotImplementedError
      end

      def []=(_key, _value)
        raise NotImplementedError
      end

      def clear
        raise NotImplementedError
      end

      def include?(_key)
        raise NotImplementedError
      end

      def delete(_key)
        raise NotImplementedError
      end
    end
  end
end
