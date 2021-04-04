# frozen_string_literal: true

module MetalArchives
  module Types
    ##
    # Boolean type
    #
    class Boolean
      # rubocop:disable Lint/BooleanSymbol
      FALSE_VALUES = [
        false, 0,
        "0", :"0",
        "f", :f,
        "F", :F,
        "false", :false,
        "FALSE", :FALSE,
        "off", :off,
        "OFF", :OFF,
      ].freeze
      # rubocop:enable Lint/BooleanSymbol

      def self.cast(value)
        !FALSE_VALUES.include?(value)
      end

      def self.serialize(value)
        value.to_s
      end
    end
  end
end

MetalArchives::Types.register(:boolean, MetalArchives::Types::Boolean)
