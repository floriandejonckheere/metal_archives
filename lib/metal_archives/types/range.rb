# frozen_string_literal: true

module MetalArchives
  module Types
    ##
    # Range type
    #
    class Range
      def self.cast(value)
        raise ArgumentError, "#{value} is not a range" unless value.is_a? ::Range

        value
      end

      def self.serialize(value)
        value&.to_s
      end
    end
  end
end

MetalArchives::Types.register(:range, MetalArchives::Types::Range)
