# frozen_string_literal: true

require "date"
require "nokogiri"

module MetalArchives
  ##
  # Represents a release
  #
  class Release < MetalArchives::BaseModel
    ##
    # :attr_reader: id
    #
    # Returns +Integer+
    #
    property :id, type: Integer

    ##
    # :attr_reader: title
    #
    # Returns +String+
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::InvalidIDError when no or invalid id
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving a status code >= 400 (except 404)
    #
    property :title

    # TODO: band

    ##
    # :attr_reader: type
    #
    # Returns +:full_length+, +:live+, +:demo+, +:single+, +:ep+, +:video+, +:boxed_set+, +:split+, +:compilation+, +:split_video+, +:collaboration+
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::InvalidIDError when no or invalid id
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving a status code >= 400 (except 404)
    #
    enum :type, values: [:full_length, :live, :demo, :single, :ep, :video, :boxed_set, :split, :compilation, :split_video, :collaboration]

    ##
    # :attr_reader: date_released
    #
    # Returns rdoc-ref:NilDate
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::InvalidIDError when no or invalid id
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving a status code >= 400 (except 404)
    #
    property :date_released, type: NilDate

    ##
    # :attr_reader_: catalog_id
    #
    # Return +String+
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::InvalidIDError when no or invalid id
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving a status code >= 400 (except 404)
    #
    property :catalog_id

    ##
    # :attr_reader_: version_description
    #
    # Return +String+
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::InvalidIDError when no or invalid id
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving a status code >= 400 (except 404)
    #
    property :version_description

    # TODO: label

    ##
    # :attr_reader: format
    #
    # Returns +:cd+, +:cassette+, +:vinyl+, +:vhs+, +:dvd+, +:digital+, +:blu_ray+, +:other+, +:unknown+
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::InvalidIDError when no or invalid id
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving a status code >= 400 (except 404)
    #
    property :format

    ##
    # :attr_reader: limitation
    #
    # Returns +Integer+
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::InvalidIDError when no or invalid id
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving a status code >= 400 (except 404)
    #
    property :limitation

    # TODO: reviews
    # TODO: songs
    # TODO: lineup
    # TODO: other versions
    # TODO: links

    ##
    # :attr_reader: notes
    #
    # Returns raw HTML +String+
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::InvalidIDError when no or invalid id
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving a status code >= 400 (except 404)
    #
    property :notes

    protected

    ##
    # Fetch the data and assemble the model
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::InvalidIDError when receiving a status code == 404
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving a status code >= 400 (except 404)
    #
    def assemble # :nodoc:
      ## Base attributes
      response = HTTPClient.get "/albums/view/id/#{id}"

      Parsers::Release.parse_html response.to_s
    end

    class << self
      ##
      # Find by ID
      #
      # Returns rdoc-ref:Release, even when ID is invalid (because the data is lazily fetched)
      #
      # [+id+]
      #     +Integer+
      #
      def find(id)
        return cache[id] if cache.include? id

        Release.new id: id
      end

      ##
      # Find by ID (no lazy loading)
      #
      # Returns rdoc-ref:Release
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
      # Refer to {MA's FAQ}[http://www.metal-archives.com/content/help?index=3#tab_db] for search tips.
      #
      # Returns rdoc-ref:Release or nil when no results
      #
      # [Raises]
      # - rdoc-ref:MetalArchives::Errors::APIError when receiving a status code >= 400
      # - rdoc-ref:MetalArchives::Errors::ParserError when parsing failed. Please report this error.
      #
      # [+query+]
      #     Hash containing one or more of the following keys:
      #     - +:band_name+: +String+
      #     - +:title+: +String+
      #     - +:from_year+: +Integer+
      #     - +:from_month+: +Integer+
      #     - +:to_year+: +Integer+
      #     - +:to_month+: +Integer+
      #     - +:country+: +ISO3166::Country+ or +Array+ of ISO3166::Country
      #     - +:location+: +String+
      #     - +:label_name+: +String+
      #     - +:indie+: +Boolean+
      #     - +:catalog_id+: +String+
      #     - +:identifier+: +String+, identifier (barcode, matrix, etc.)
      #     - +:recording_info+: +String+, recording information (studio, city, etc.)
      #     - +:version_description+: +String+, version description (country, digipak, etc.)
      #     - +:notes+: +String+
      #     - +:genre+: +String+
      #     - +:types+: +Array+ of +Symbol+, see rdoc-ref:Release.type
      #     - +:formats+: +Array+ of +Symbol+, see rdoc-ref:Release.format
      #
      def find_by(query)
        params = Parsers::Release.map_params query

        response = HTTPClient.get "/search/ajax-advanced/searching/albums", params
        json = JSON.parse response.to_s

        return nil if json["aaData"].empty?

        data = json["aaData"].first
        id = Nokogiri::HTML(data[1]).xpath("//a/@href").first.value.delete('\\').split("/").last.gsub(/\D/, "").to_i

        find id
      end

      ##
      # Find by attributes (no lazy loading)
      #
      # Refer to {MA's FAQ}[http://www.metal-archives.com/content/help?index=3#tab_db] for search tips.
      #
      # Returns rdoc-ref:Release or nil when no results
      #
      # [Raises]
      # - rdoc-ref:MetalArchives::Errors::APIError when receiving a status code >= 400
      # - rdoc-ref:MetalArchives::Errors::ParserError when parsing failed. Please report this error.
      #
      # [+query+]
      #     Hash containing one or more of the following keys:
      #     - +:band_name+: +String+
      #     - +:title+: +String+
      #     - +:from_year+: +Integer+
      #     - +:from_month+: +Integer+
      #     - +:to_year+: +Integer+
      #     - +:to_month+: +Integer+
      #     - +:country+: +ISO3166::Country+ or +Array+ of ISO3166::Country
      #     - +:location+: +String+
      #     - +:label_name+: +String+
      #     - +:indie+: +Boolean+
      #     - +:catalog_id+: +String+
      #     - +:identifier+: +String+, identifier (barcode, matrix, etc.)
      #     - +:recording_info+: +String+, recording information (studio, city, etc.)
      #     - +:version_description+: +String+, version description (country, digipak, etc.)
      #     - +:notes+: +String+
      #     - +:genre+: +String+
      #     - +:types+: +Array+ of +Symbol+, see rdoc-ref:Release.type
      #     - +:formats+: +Array+ of +Symbol+, see rdoc-ref:Release.format
      #
      def find_by!(query)
        obj = find_by query
        obj.load! if obj && !obj.loaded?

        obj
      end

      ##
      # Search by attributes
      #
      # Refer to {MA's FAQ}[http://www.metal-archives.com/content/help?index=3#tab_db] for search tips.
      #
      # Returns rdoc-ref:Collection of rdoc-ref:Release
      #
      # [Raises]
      # - rdoc-ref:MetalArchives::Errors::APIError when receiving a status code >= 400
      # - rdoc-ref:MetalArchives::Errors::ParserError when parsing failed. Please report this error.
      #
      # [+query+]
      #     Hash containing one or more of the following keys:
      #     - +:band_name+: +String+
      #     - +:title+: +String+
      #     - +:from_year+: +Integer+
      #     - +:from_month+: +Integer+
      #     - +:to_year+: +Integer+
      #     - +:to_month+: +Integer+
      #     - +:country+: +ISO3166::Country+ or +Array+ of ISO3166::Country
      #     - +:location+: +String+
      #     - +:label_name+: +String+
      #     - +:indie+: +Boolean+
      #     - +:catalog_id+: +String+
      #     - +:identifier+: +String+, identifier (barcode, matrix, etc.)
      #     - +:recording_info+: +String+, recording information (studio, city, etc.)
      #     - +:version_description+: +String+, version description (country, digipak, etc.)
      #     - +:notes+: +String+
      #     - +:genre+: +String+
      #     - +:types+: +Array+ of +Symbol+, see rdoc-ref:Release.type
      #     - +:formats+: +Array+ of +Symbol+, see rdoc-ref:Release.format
      #
      def search_by(query)
        params = Parsers::Release.map_params query

        l = lambda do
          @start ||= 0

          if @max_items && @start >= @max_items
            []
          else
            response = HTTPClient.get "/search/ajax-advanced/searching/albums", params.merge(iDisplayStart: @start)
            json = JSON.parse response.to_s

            @max_items = json["iTotalRecords"]

            objects = []

            json["aaData"].each do |data|
              # Create Release object for every ID in the results list
              id = Nokogiri::HTML(data.first).xpath("//a/@href").first.value.delete('\\').split("/").last.gsub(/\D/, "").to_i
              objects << Release.find(id)
            end

            @start += 200

            objects
          end
        end

        MetalArchives::Collection.new l
      end

      ##
      # Search by title, resolves to rdoc-ref:Release.search_by <tt>(:title => title)</tt>
      #
      # Refer to {MA's FAQ}[http://www.metal-archives.com/content/help?index=3#tab_db] for search tips.
      #
      # Returns (possibly empty) +Array+ of rdoc-ref:Release
      #
      # [Raises]
      # - rdoc-ref:MetalArchives::Errors::APIError when receiving a status code >= 400
      # - rdoc-ref:MetalArchives::Errors::ArgumentError when +title+ isn't a +String+
      #
      # [+title+]
      #     +String+
      #
      def search(title)
        raise MetalArchives::Errors::ArgumentError unless title.is_a? String

        search_by title: title
      end

      ##
      # Get all releases
      #
      # Returns rdoc-ref:Collection of rdoc-ref:Release
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
