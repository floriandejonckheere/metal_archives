require 'date'
require 'countries'

module MetalArchives
module Parsers # :nodoc:
  ##
  # Parsing utilities
  #
  class ParserHelper # :nodoc:
    class << self
      ##
      # Parse a country
      #
      # Returns +ISO3166::Country+
      #
      def parse_country(input)
        ISO3166::Country.find_country_by_name (input)
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
      # For examples on how genres are parsed, refer to +ParserHelperTest::test_parse_genre+
      #
      def parse_genre(input)
        genres = []
        # Split fields
        input.split(',').each do |genre|
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
          temp = ['']
          genre.downcase.split.reject { |g| ['(early)', '(later)', 'metal'].include? g }.each do |g|
            unless g.include? '/'
              temp.map! { |t| t.empty? ? g.capitalize : "#{t.capitalize} #{g.capitalize}" }
            else
              # Duplicate all WIP genres
              temp2 = temp.dup

              # Assign first and last components to temp and temp2 respectively
              split = g.split '/'
              temp.map! { |t| t.empty? ? split.first.capitalize : "#{t.capitalize} #{split.first.capitalize}" }
              temp2.map! { |t| t.empty? ? split.last.capitalize : "#{t.capitalize} #{split.last.capitalize}" }

              # Add both genre trees
              temp += temp2
            end
          end
          genres += temp
        end
        genres.uniq
      end
    end
  end
end
end
