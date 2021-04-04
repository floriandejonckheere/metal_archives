# frozen_string_literal: true

module MetalArchives
  module Types
    ##
    # Country type
    #
    class Country
      def self.cast(value)
        return value if value.is_a? ISO3166::Country

        ISO3166::Country[value]
      end

      def self.serialize(value)
        value&.alpha2
      end
    end
  end
end

MetalArchives::Types.register(:country, MetalArchives::Types::Country)
