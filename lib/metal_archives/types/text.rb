# frozen_string_literal: true

module MetalArchives
  module Types
    ##
    # Text type (raw string)
    #
    class Text
      def self.cast(value)
        value&.to_s
      end

      def self.serialize(value)
        value&.to_s
      end
    end
  end
end

MetalArchives::Types.register(:text, MetalArchives::Types::Text)
