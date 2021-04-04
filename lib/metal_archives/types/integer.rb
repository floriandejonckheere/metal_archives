# frozen_string_literal: true

module MetalArchives
  module Types
    ##
    # Integer type
    #
    class Integer
      def self.cast(value)
        Kernel.Integer(value) if value
      end

      def self.serialize(value)
        value.to_s
      end
    end
  end
end

MetalArchives::Types.register(:integer, MetalArchives::Types::Integer)
