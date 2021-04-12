# frozen_string_literal: true

module MetalArchives
  module Types
    ##
    # Symbol type
    #
    class Symbol
      def self.cast(value)
        return if value.blank?

        value
          .to_s
          .gsub(/^"/, "")
          .gsub(/"$/, "")
          .gsub(/[[:space:]]/, " ")
          .tr("-", "_")
          .strip
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
