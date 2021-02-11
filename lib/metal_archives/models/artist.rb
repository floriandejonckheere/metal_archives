# frozen_string_literal: true

require "date"
require "countries"
require "nokogiri"

module MetalArchives
  ##
  # Represents a single performer (but not a solo artist)
  #
  class Artist < Base
    ##
    # :attr_reader: id
    #
    # Returns +Integer+
    #
    property :id, type: Integer

    ##
    # :attr_reader: name
    #
    # Returns +String+
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::InvalidIDError when no or invalid id
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving a status code >= 400 (except 404)
    #
    property :name

    ##
    # :attr_reader: aliases
    #
    # Returns +Array+ of +String+
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::InvalidIDError when no or invalid id
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving a status code >= 400 (except 404)
    #
    property :aliases, multiple: true

    ##
    # :attr_reader: country
    #
    # Returns +ISO3166::Country+
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::InvalidIDError when no or invalid id
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving a status code >= 400 (except 404)
    #
    property :country, type: ISO3166::Country

    ##
    # :attr_reader: location
    #
    # Returns +String+
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::InvalidIDError when no or invalid id
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving a status code >= 400 (except 404)
    #
    property :location

    ##
    # :attr_reader: date_of_birth
    #
    # Returns rdoc-ref:Date
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::InvalidIDError when no or invalid id
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving a status code >= 400 (except 404)
    #
    property :date_of_birth, type: Date

    ##
    # :attr_reader: date_of_death
    #
    # Returns rdoc-ref:Date
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::InvalidIDError when no or invalid id
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving a status code >= 400 (except 404)
    #
    property :date_of_death, type: Date

    ##
    # :attr_reader: cause_of_death
    #
    # Returns +String+
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::InvalidIDError when no or invalid id
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving a status code >= 400 (except 404)
    #
    property :cause_of_death

    ##
    # :attr_reader: gender
    #
    # Returns +Symbol+, either +:male+ or +:female+
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::InvalidIDError when no or invalid id
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving a status code >= 400 (except 404)
    #
    enum :gender, values: [:male, :female]

    ##
    # :attr_reader: biography
    #
    # Returns raw HTML +String+
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::InvalidIDError when no or invalid id
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving a status code >= 400 (except 404)
    #
    property :biography

    ##
    # :attr_reader: trivia
    #
    # Returns raw HTML +String+
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::InvalidIDError when no or invalid id
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving a status code >= 400 (except 404)
    #
    property :trivia

    ##
    # :attr_reader: photo
    #
    # Returns +URI+ (rewritten if config option was enabled)
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::InvalidIDError when no or invalid id
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving a status code >= 400 (except 404)
    #
    property :photo

    ##
    # :attr_reader: links
    #
    # Returns +Array+ of +Hash+ containing the following keys
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::InvalidIDError when no or invalid id
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving a status code >= 400 (except 404)
    #
    # [+links+]
    #     - +:url+: +String+
    #     - +:type+: +Symbol+, either +:official+, +:unofficial+ or +:unlisted_bands+
    #     - +:title+: +String+
    #
    property :links, multiple: true

    ##
    # :attr_reader: bands
    #
    # Returns +Array+ of +Hash+ containing the following keys
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::InvalidIDError when no or invalid id
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving a status code >= 400 (except 404)
    #
    # [+bands+]
    #     - +:band+: rdoc-ref:Band
    #     - +:active+: Boolean
    #     - +:years_active+: +Array+ of rdoc-ref:Range containing +Integer+
    #     - +:role+: +String+
    #
    property :bands, type: Hash, multiple: true

    # TODO: guest/session bands
    # TODO: misc bands

    protected

    ##
    # Fetch the data and assemble the model
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::InvalidIDError when no or invalid id
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving a status code >= 400 (except 404)
    #
    def assemble # :nodoc:
      ## Base attributes
      response = MetalArchives.http.get "/artist/view/id/#{id}"

      properties = Parsers::Artist.parse_html response.to_s

      ## Biography
      response = MetalArchives.http.get "/artist/read-more/id/#{id}/field/biography"

      properties[:biography] = response.to_s

      ## Trivia
      response = MetalArchives.http.get "/artist/read-more/id/#{id}/field/trivia"

      properties[:trivia] = response.to_s

      ## Related links
      response = MetalArchives.http.get "/link/ajax-list/type/person/id/#{id}"

      properties[:links] = Parsers::Artist.parse_links_html response.to_s

      properties
    end

    class << self
      ##
      # Find by ID
      #
      # Returns rdoc-ref:Artist, even when ID is invalid (because the data is lazily fetched)
      #
      # [+id+]
      #     +Integer+
      #
      def find(id)
        return MetalArchives.cache[id] if MetalArchives.cache.include? id

        Artist.new id: id
      end

      ##
      # Find by ID (no lazy loading)
      #
      # Returns rdoc-ref:Artist
      #
      # [Raises]
      # - rdoc-ref:MetalArchives::Errors::InvalidIDError when no or invalid id
      # - rdoc-ref:MetalArchives::Errors::APIError when receiving a status code >= 400 (except 404)
      # - rdoc-ref:MetalArchives::Errors::ParserError when parsing failed. Please report this error.
      #
      # [+id+]
      #     +Integer+
      #
      def find!(id)
        obj = find id
        obj.load! if obj && !obj.loaded?

        obj
      end

      ##
      # Find by attributes
      #
      # Returns rdoc-ref:Artist or nil when no results
      #
      # [Raises]
      # - rdoc-ref:MetalArchives::Errors::APIError when receiving a status code >= 400
      # - rdoc-ref:MetalArchives::Errors::ParserError when parsing failed. Please report this error.
      # - rdoc-ref:MetalArchives::Errors::ArgumentError when query contains no :name key
      #
      # [+query+]
      #     Hash containing one or more of the following keys:
      #     - +:name+: +String+
      #
      def find_by(query)
        raise MetalArchives::Errors::ArgumentError unless query.include? :name

        params = Parsers::Artist.map_params query

        response = MetalArchives.http.get "/search/ajax-artist-search/", params
        json = JSON.parse response.to_s

        return nil if json["aaData"].empty?

        data = json["aaData"].first
        id = Nokogiri::HTML(data.first).xpath("//a/@href").first.value.delete('\\').split("/").last.gsub(/\D/, "").to_i

        find id
      end

      ##
      # Find by attributes (no lazy loading)
      #
      # Returns rdoc-ref:Artist or nil when no results
      #
      # [Raises]
      # - rdoc-ref:MetalArchives::Errors::InvalidIDError when no or invalid id
      # - rdoc-ref:MetalArchives::Errors::APIError when receiving a status code >= 400
      # - rdoc-ref:MetalArchives::Errors::ParserError when parsing failed. Please report this error.
      # - rdoc-ref:MetalArchives::Errors::ArgumentError when query contains no :name key
      #
      # [+query+]
      #     Hash containing one or more of the following keys:
      #     - +:name+: +String+
      #
      def find_by!(query)
        obj = find_by query
        obj.load! if obj && !obj.loaded?

        obj
      end

      ##
      # Search by name
      #
      # Returns rdoc-ref:Collection of rdoc-ref:Artist
      #
      # [Raises]
      # - rdoc-ref:MetalArchives::Errors::APIError when receiving a status code >= 400
      # - rdoc-ref:MetalArchives::Errors::ParserError when parsing failed. Please report this error.
      # - rdoc-ref:MetalArchives::Errors::ArgumentError when +name+ isn't a +String+
      #
      # [+name+]
      #     +String+
      #
      def search(name)
        raise MetalArchives::Errors::ArgumentError unless name.is_a? String

        query = { name: name }

        params = Parsers::Artist.map_params query

        l = lambda do
          @start ||= 0

          if @max_items && @start >= @max_items
            []
          else
            response = MetalArchives.http.get "/search/ajax-artist-search/", params.merge(iDisplayStart: @start)
            json = JSON.parse response.to_s

            @max_items = json["iTotalRecords"]

            objects = []

            json["aaData"].each do |data|
              # Create Artist object for every ID in the results list
              id = Nokogiri::HTML(data.first).xpath("//a/@href").first.value.delete('\\').split("/").last.gsub(/\D/, "").to_i
              objects << Artist.find(id)
            end

            @start += 200

            objects
          end
        end

        MetalArchives::Collection.new l
      end

      ##
      # Get all artists
      #
      # Returns rdoc-ref:Collection of rdoc-ref:Artist
      #
      # [Raises]
      # - rdoc-ref:MetalArchives::Errors::APIError when receiving a status code >= 400
      # - rdoc-ref:MetalArchives::Errors::ParserError when parsing failed. Please report this error.
      #
      def all
        search ""
      end
    end
  end
end
