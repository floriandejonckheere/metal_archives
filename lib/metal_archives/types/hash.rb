# frozen_string_literal: true

module MetalArchives
  module Types
    ##
    # Hash type
    #
    class Hash
      def self.cast(value)
        value&.to_h
      end

      def self.serialize(value)
        value&.to_s
      end
    end
  end
end

MetalArchives::Types.register(:hash, MetalArchives::Types::Hash)
