# frozen_string_literal: true

require "date"
require "countries"

module MetalArchives
  ##
  # Mapping layer from and to MA Web Service
  #
  module Parsers # :nodoc:
    ##
    # Parser base class
    #
    class Parser
      class << self
        ##
        # Parse a country
        #
        # Returns +ISO3166::Country+
        #
        def parse_country(input)
          ISO3166::Country.find_country_by_name input
        end

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
        end

        ##
        # Opinionated parsing of genres
        #
        # Returns an +Array+ of +String+
        #
        # The following components are omitted:
        # - Metal
        # - (early)
        # - (later)
        #
        # All genres are capitalized.
        #
        # For examples on how genres are parsed, refer to +ParserTest#test_parse_genre+
        #
        def parse_genre(input)
          genres = []
          # Split fields
          input.split(",").each do |genre|
            ##
            # Start with a single empty genre string. Split the genre by spaces
            # and process each component. If a component does not have a slash,
            # concatenate it to all genre strings present in +temp+. If it does
            # have a slash present, duplicate all genre strings, and concatenate
            # the first component (before the slash) to the first half, and the
            # last component to the last half. +temp+ now has an array of genre
            # combinations.
            #
            # 'Traditional Heavy/Power Metal' => ['Traditional Heavy', 'Traditional Power']
            # 'Traditional/Classical Heavy/Power Metal' => [
            #                                       'Traditional Heavy', 'Traditional Power',
            #                                       'Classical Heavy', 'Classical Power']
            #
            temp = [""]

            suffixes = %w((early) (later) metal).freeze

            genre.downcase.split.reject { |g| suffixes.include? g }.each do |g|
              if g.include? "/"
                # Duplicate all WIP genres
                temp2 = temp.dup

                # Assign first and last components to temp and temp2 respectively
                split = g.split "/"
                temp.map! { |t| t.empty? ? split.first.capitalize : "#{t.capitalize} #{split.first.capitalize}" }
                temp2.map! { |t| t.empty? ? split.last.capitalize : "#{t.capitalize} #{split.last.capitalize}" }

                # Add both genre trees
                temp += temp2
              else
                temp.map! { |t| t.empty? ? g.capitalize : "#{t.capitalize} #{g.capitalize}" }
              end
            end
            genres += temp
          end
          genres.uniq
        end

        ##
        # Parse year range
        #
        def parse_year_range(input)
          r = input.split("-")
          date_start = (r.first == "?" ? nil : NilDate.new(r.first.to_i))
          date_end = if r.length > 1
                       (r.last == "?" || r.last == "present" ? nil : NilDate.new(r.last.to_i))
                     else
                       date_start.dup
                     end

          MetalArchives::Range.new date_start, date_end
        end
      end
    end
  end
end
