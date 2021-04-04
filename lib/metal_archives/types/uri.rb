# frozen_string_literal: true

module MetalArchives
  module Types
    ##
    # URI type
    #
    class URI
      def self.cast(value)
        return value if value.is_a? ::URI

        Kernel.URI(value)
      end

      def self.serialize(value)
        value&.to_s
      end
    end
  end
end

MetalArchives::Types.register(:uri, MetalArchives::Types::URI)
