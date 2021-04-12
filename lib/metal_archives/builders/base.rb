# frozen_string_literal: true

module MetalArchives
  module Builders
    ##
    # Abstract builder
    #
    class Base
      GENRE_SUFFIXES = %w((early) (later) metal).freeze

      def build!
        raise NotImplementedError
      end

      def http
        MetalArchives.http
      end

      ##
      # Parse a string
      #
      # [Params]
      # - +string+: +String+
      #
      # [Returns]
      # - +string+
      #
      def string(string)
        Types::String.cast(string)
      end

      ##
      # Parse a symbol
      #
      # [Params]
      #- +string+: +String+
      #
      # [Returns]
      # - +string+
      #
      def symbol(string)
        Types::Symbol.cast(string)
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

      ##
      # Parse a year range
      #
      # [Params]
      # - +string+: Year range +String+
      #
      # [Returns]
      # - +Range+ of +Integer+
      #
      def year(string)
        return if string.blank?
        return string if string.is_a?(Range)

        components = string
          .split("-")
          .map(&:to_i)
          .map { |y| y.zero? ? nil : y }

        return if components.empty?

        # Set end if only one year
        components << components.first if components.count == 1

        components[0]..components[1]
      end

      ##
      # Parse a years active string
      #
      # [Params]
      # +string+: Years active +String+
      #
      # [Returns]
      # +Array+ of +Range+ (years active), +Array+ of +String+ (aliases)
      #
      def years(string)
        return nil if string.blank?

        # Split by comma and then extract aliases
        years, aliases = string
          .split(",")
          .map { |s| s.match(/ *(?<years>[^(]*)(\(as (?<aliases>[^)]*)\))?/).captures }
          .transpose

        years = years.map { |y| year(y) }
        aliases = aliases.compact

        [years, aliases]
      end

      ##
      # Parse a genre string
      #
      # The following components are omitted:
      # - Metal
      # - (early)
      # - (later)
      #
      # All genres are capitalized.
      #
      # [Params]
      # +string+: Genre +String+
      #
      # [Returns]
      # +Array+ of +String+
      #
      def genres(string)
        return [] if string.blank?

        genres = []

        # Split fields
        string.split(/[,;]/).each do |genre|
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

          genre.downcase.split.reject { |g| GENRE_SUFFIXES.include? g }.each do |g|
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
      # Parse a lyrical themes string
      #
      # [Params]
      # +string+: Lyrical themes +String+
      #
      # [Returns]
      # +Array+ of +String+
      #
      def lyrical_themes(string)
        return nil if string.blank?

        string
          .split(",")
          .map(&:strip)
      end
    end
  end
end
