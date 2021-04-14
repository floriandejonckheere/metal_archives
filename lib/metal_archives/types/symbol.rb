# frozen_string_literal: true

module MetalArchives
  module Types
    ##
    # Symbol type
    #
    class Symbol
      def self.cast(value)
        return if value.blank?

        String
          .cast(value)
          .tr("-", "_")
          .parameterize(separator: "_")
          .to_sym
      end

      def self.serialize(value)
        value&.to_s
      end
    end
  end
end

MetalArchives::Types.register(:symbol, MetalArchives::Types::Symbol)
