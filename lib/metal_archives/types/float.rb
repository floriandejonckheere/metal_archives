# frozen_string_literal: true

module MetalArchives
  module Types
    ##
    # Float type
    #
    class Float
      def self.cast(value)
        Kernel.Float(value) if value
      end

      def self.serialize(value)
        value.to_s
      end
    end
  end
end

MetalArchives::Types.register(:float, MetalArchives::Types::Float)
