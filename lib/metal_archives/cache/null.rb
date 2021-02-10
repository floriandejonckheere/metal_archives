# frozen_string_literal: true

module MetalArchives
  module Cache
    ##
    # Null cache
    #
    class Null < Base
      def [](_key); end

      def []=(_key, _value); end

      def clear; end

      def include?(_key)
        false
      end

      def delete(_key); end
    end
  end
end
