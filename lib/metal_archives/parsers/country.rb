# frozen_string_literal: true

module MetalArchives
  module Parsers
    ##
    # Country parser
    #
    class Country < Base
      ##
      # Parse a country
      #
      # Returns +ISO3166::Country+
      #
      def self.parse(input)
        ISO3166::Country.find_country_by_name(input)
      end
    end
  end
end
