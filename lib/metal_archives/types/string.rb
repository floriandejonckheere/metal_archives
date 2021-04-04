# frozen_string_literal: true

module MetalArchives
  module Types
    ##
    # String type
    #
    class String
      def self.cast(value)
        value&.to_s
      end

      def self.serialize(value)
        value&.to_s
      end
    end
  end
end

MetalArchives::Types.register(:string, MetalArchives::Types::String)
