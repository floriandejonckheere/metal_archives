# frozen_string_literal: true

module MetalArchives
  ##
  # Represents a single performer (but not a solo artist)
  #
  class Artist < Base
    ##
    # :attr_reader: id
    #
    # [Returns]
    # - +Integer+
    #
    attribute :id, type: :integer

    ##
    # :attr_reader: name
    #
    # [Returns]
    # - +String+
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::ParserError when parsing failed. Please report this error.
    # - rdoc-ref:MetalArchives::Errors::NotFoundError when receiving status code 404
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving status code >= 400
    #
    attribute :name

    ##
    # :attr_reader: aliases
    #
    # [Returns]
    # - +Array+ of +String+
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::ParserError when parsing failed. Please report this error.
    # - rdoc-ref:MetalArchives::Errors::NotFoundError when receiving status code 404
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving status code >= 400
    #
    attribute :aliases, multiple: true

    ##
    # :attr_reader: country
    #
    # [Returns]
    # - +ISO3166::Country+
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::ParserError when parsing failed. Please report this error.
    # - rdoc-ref:MetalArchives::Errors::NotFoundError when receiving status code 404
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving status code >= 400
    #
    attribute :country, type: :country

    ##
    # :attr_reader: location
    #
    # [Returns]
    # - +String+
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::ParserError when parsing failed. Please report this error.
    # - rdoc-ref:MetalArchives::Errors::NotFoundError when receiving status code 404
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving status code >= 400
    #
    attribute :location

    ##
    # :attr_reader: date_of_birth
    #
    # [Returns]
    # - +Date+
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::ParserError when parsing failed. Please report this error.
    # - rdoc-ref:MetalArchives::Errors::NotFoundError when receiving status code 404
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving status code >= 400
    #
    attribute :date_of_birth, type: :date

    ##
    # :attr_reader: date_of_death
    #
    # [Returns]
    # - +Date+
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::ParserError when parsing failed. Please report this error.
    # - rdoc-ref:MetalArchives::Errors::NotFoundError when receiving status code 404
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving status code >= 400
    #
    attribute :date_of_death, type: :date

    ##
    # :attr_reader: cause_of_death
    #
    # [Returns]
    # - +String+
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::ParserError when parsing failed. Please report this error.
    # - rdoc-ref:MetalArchives::Errors::NotFoundError when receiving status code 404
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving status code >= 400
    #
    attribute :cause_of_death

    ##
    # :attr_reader: gender
    #
    # [Returns]
    # - +Symbol+, one of +:male+ or +:female+
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::ParserError when parsing failed. Please report this error.
    # - rdoc-ref:MetalArchives::Errors::NotFoundError when receiving status code 404
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving status code >= 400
    #
    attribute :gender, type: :symbol, enum: [:male, :female]

    ##
    # :attr_reader: biography
    #
    # [Returns]
    # - raw HTML +String+
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::ParserError when parsing failed. Please report this error.
    # - rdoc-ref:MetalArchives::Errors::NotFoundError when receiving status code 404
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving status code >= 400
    #
    attribute :biography

    ##
    # :attr_reader: trivia
    #
    # [Returns]
    # - raw HTML +String+
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::ParserError when parsing failed. Please report this error.
    # - rdoc-ref:MetalArchives::Errors::NotFoundError when receiving status code 404
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving status code >= 400
    #
    attribute :trivia

    ##
    # :attr_reader: photo
    #
    # [Returns]
    # - +URI+ (rewritten if config option was enabled)
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::ParserError when parsing failed. Please report this error.
    # - rdoc-ref:MetalArchives::Errors::NotFoundError when receiving status code 404
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving status code >= 400
    #
    attribute :photo, type: :uri

    ##
    # :attr_reader: links
    #
    # [Returns]
    # - +Array+ of +Hash+ containing the following keys:
    #
    # [+links+]
    #   - +:url+: +String+
    #   - +:type+: +Symbol+, either +:official+, +:unofficial+ or +:unlisted_bands+
    #   - +:title+: +String+
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::ParserError when parsing failed. Please report this error.
    # - rdoc-ref:MetalArchives::Errors::NotFoundError when receiving status code 404
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving status code >= 400
    #
    attribute :links, type: :hash, multiple: true

    ##
    # :attr_reader: bands
    #
    # [Returns]
    # - +Array+ of +Hash+ containing the following keys
    #
    # [+bands+]
    #   - +:band+: rdoc-ref:Band
    #   - +:active+: Boolean
    #   - +:years_active+: +Array+ of rdoc-ref:Range containing +Integer+
    #   - +:role+: +String+
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::ParserError when parsing failed. Please report this error.
    # - rdoc-ref:MetalArchives::Errors::NotFoundError when receiving status code 404
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving status code >= 400
    #
    attribute :bands, type: :hash, multiple: true

    # TODO: guest/session bands
    # TODO: misc bands

    class << self
      ##
      # Find by attributes
      #
      # [Params]
      # - +query+: +Hash+ containing one or more of the following keys:
      #   - +name+: +String+
      #
      # [Returns]
      # - rdoc-ref:MetalArchives::Artist or +nil+
      #
      # [Raises]
      # - rdoc-ref:MetalArchives::Errors::ParserError when parsing failed. Please report this error.
      # - rdoc-ref:MetalArchives::Errors::APIError when receiving status code >= 400
      #
      def find_by(query)
        params = { query: CGI.escape(query.fetch(:name)) }

        json = JSON
          .parse(MetalArchives.http.get("/search/ajax-artist-search/", params).body.to_s)
          .dig("aaData", 0, 0)

        return unless json

        url = Nokogiri::HTML(CGI.unescapeHTML(json))
          .at("a")
          .attr("href")

        return unless url

        id = Types::URI.cast(url).path.split("/").last.to_i

        return unless id

        find(id)
      end

      ##
      # Find by attributes
      #
      # [Params]
      # - +query+: +Hash+ containing one or more of the following keys:
      #   - +name+: +String+
      #
      # [Returns]
      # - rdoc-ref:MetalArchives::Artist
      #
      # [Raises]
      # - rdoc-ref:MetalArchives::Errors::ParserError when parsing failed. Please report this error.
      # - rdoc-ref:MetalArchives::Errors::NotFoundError when receiving status code 404
      # - rdoc-ref:MetalArchives::Errors::APIError when receiving status code >= 400
      #
      def find_by!(query)
        find_by(query)
          &.tap(&:load!)
      end

      ##
      # Search by name
      #
      # [Params]
      # - +query+: +Hash+ containing one or more of the following keys:
      #   - +name+: +String+
      #
      # [Returns]
      # - rdoc-ref:Collection of rdoc-ref:Artist
      #
      # [Raises]
      # - rdoc-ref:MetalArchives::Errors::ParserError when parsing failed. Please report this error.
      # - rdoc-ref:MetalArchives::Errors::APIError when receiving status code >= 400
      #
      def search(query)
        params = { query: CGI.escape(query.fetch(:name)) }

        MetalArchives.Collection(Artist).new("/search/ajax-artist-search/", params)
      end

      ##
      # Get all artists
      #
      # Returns rdoc-ref:Collection of rdoc-ref:Artist
      #
      # [Raises]
      # - rdoc-ref:MetalArchives::Errors::ParserError when parsing failed. Please report this error.
      # - rdoc-ref:MetalArchives::Errors::APIError when receiving status code >= 400
      #
      def all
        search ""
      end
    end
  end
end
