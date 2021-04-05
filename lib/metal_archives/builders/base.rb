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
      # - +nil+ if string is blank
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

      ##
      # Parse a date
      #
      # [Params]
      # - +string+: Date +String+
      #
      # [Returns]
      # - +Date+
      # - +nil+ if date cannot be parsed
      #
      def date(string)
        return if string.blank?
        return string if string.is_a?(Date)

        Date.parse(string)
      rescue Date::Error
        components = string
          .split("-")
          .map(&:to_i)
          .reject(&:zero?)
          .compact

        return if components.empty?

        Date.new(*components)
      rescue ArgumentError
        nil
      end
    end
  end
end
