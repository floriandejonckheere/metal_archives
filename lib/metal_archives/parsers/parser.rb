# frozen_string_literal: true

require "date"

module MetalArchives
  module Parsers
    ##
    # Parser base class
    #
    class Parser
      class << self
        ##
        # Sanitize a string
        #
        # Return +String+
        #
        def sanitize(input)
          input.gsub(/^"/, "").gsub(/"$/, "").strip
        end

        ##
        # Rewrite a URL
        #
        # Return +URI+
        #
        def rewrite(input)
          return input unless MetalArchives.config.endpoint

          endpoint = URI(MetalArchives.config.endpoint)

          URI(input)
            .tap { |u| u.host = endpoint.host }
            .tap { |u| u.scheme = endpoint.scheme }
            .to_s
        end
      end
    end
  end
end
