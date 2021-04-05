# frozen_string_literal: true

module MetalArchives
  module Builders
    ##
    # Abstract builder
    #
    class Base
      def build!
        raise NotImplementedError
      end

      def http
        MetalArchives.http
      end

      ##
      # Parse a URI and rewrite host if necessary
      #
      # [Params]
      # - +string+: URI +String+
      #
      # [Returns]
      # - +URI+
      #
      def uri(string)
        return if string.blank?

        string = URI(string) unless string.is_a?(URI)

        # Rewrite host if necessary
        return string unless MetalArchives.config.endpoint

        endpoint = URI(MetalArchives.config.endpoint)

        string
          .tap { |u| u.host = endpoint.host }
          .tap { |u| u.scheme = endpoint.scheme }
          .tap { |u| u.port = endpoint.port }
      end
    end
  end
end
