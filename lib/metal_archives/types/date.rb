# frozen_string_literal: true

module MetalArchives
  module Types
    ##
    # Date type
    #
    class Date
      def self.cast(value)
        return value if value.is_a? ::Date

        ::Date.parse(value) if value
      end

      def self.serialize(value)
        value.iso8601
      end
    end
  end
end

MetalArchives::Types.register(:date, MetalArchives::Types::Date)
