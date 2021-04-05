# frozen_string_literal: true

module MetalArchives
  module Types
    ##
    # String type
    #
    class String
      def self.cast(value)
        return if value.blank?

        value
          .to_s
          .gsub(/^"/, "")
          .gsub(/"$/, "")
          .gsub(/[[:space:]]/, " ")
          .gsub(%r(</?[^>]*>), "") # Parsing HTML with regex is generally a Very Bad Idea
          .strip
      end

      def self.serialize(value)
        value&.to_s
      end
    end
  end
end

MetalArchives::Types.register(:string, MetalArchives::Types::String)
