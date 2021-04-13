# frozen_string_literal: true

module MetalArchives
  ##
  # Represents a release
  #
  class Release < Base
    ##
    # :attr_reader: id
    #
    # [Returns]
    # - +Integer+
    #
    attribute :id, type: :integer

    ##
    # :attr_reader: title
    #
    # [Returns]
    # - +String+
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::ParserError when parsing failed. Please report this error.
    # - rdoc-ref:MetalArchives::Errors::NotFoundError when receiving status code 404
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving status code >= 400
    #
    attribute :title

    ##
    # :attr_reader: band
    #
    # [Returns]
    # - +rdoc-ref:MetalArchives::Band+
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::ParserError when parsing failed. Please report this error.
    # - rdoc-ref:MetalArchives::Errors::NotFoundError when receiving status code 404
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving status code >= 400
    #
    attribute :band, type: :band

    ##
    # :attr_reader: label
    #
    # [Returns]
    # - +rdoc-ref:MetalArchives::Label+
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::ParserError when parsing failed. Please report this error.
    # - rdoc-ref:MetalArchives::Errors::NotFoundError when receiving status code 404
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving status code >= 400
    #
    attribute :label, type: :label

    ##
    # :attr_reader: type
    #
    # [Returns]
    # - +Symbol+: one of +:full_length+, +:live+, +:demo+, +:single+, +:ep+, +:video+, +:boxed_set+, +:split+, +:compilation+, +:split_video+ or +:collaboration+
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::ParserError when parsing failed. Please report this error.
    # - rdoc-ref:MetalArchives::Errors::NotFoundError when receiving status code 404
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving status code >= 400
    #
    attribute :type, type: :symbol, enum: [:full_length, :live, :demo, :single, :ep, :video, :boxed_set, :split, :compilation, :split_video, :collaboration]

    ##
    # :attr_reader: date_released
    #
    # [Returns]
    # - +Date+
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::ParserError when parsing failed. Please report this error.
    # - rdoc-ref:MetalArchives::Errors::NotFoundError when receiving status code 404
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving status code >= 400
    #
    attribute :date_released, type: :date

    ##
    # :attr_reader: catalog_id
    #
    # [Returns]
    # - +String+
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::ParserError when parsing failed. Please report this error.
    # - rdoc-ref:MetalArchives::Errors::NotFoundError when receiving status code 404
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving status code >= 400
    #
    attribute :catalog_id

    ##
    # :attr_reader: version_description
    #
    # [Returns]
    # - +String+
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::ParserError when parsing failed. Please report this error.
    # - rdoc-ref:MetalArchives::Errors::NotFoundError when receiving status code 404
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving status code >= 400
    #
    attribute :version_description

    ##
    # :attr_reader: format
    #
    # [Returns]
    # - +Symbol+, one of +:cd+, +:cassette+, +:vinyl+, +:vhs+, +:dvd+, +:2dvd+, +:digital+, +:blu_ray+, +:other+ or +:unknown+
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::ParserError when parsing failed. Please report this error.
    # - rdoc-ref:MetalArchives::Errors::NotFoundError when receiving status code 404
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving status code >= 400
    #
    attribute :format, type: :symbol, enum: [:cd, :"2cd", :cassette, :vinyl, :vhs, :dvd, :"2dvd", :digital, :blu_ray, :other, :unknown]

    ##
    # :attr_reader: limitation
    #
    # [Returns]
    # - +Integer+
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::ParserError when parsing failed. Please report this error.
    # - rdoc-ref:MetalArchives::Errors::NotFoundError when receiving status code 404
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving status code >= 400
    #
    attribute :limitation, type: :integer

    # TODO: reviews
    # TODO: songs
    # TODO: lineup
    # TODO: other versions
    # TODO: links

    ##
    # :attr_reader: notes
    #
    # [Returns]
    # - raw HTML +String+
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::ParserError when parsing failed. Please report this error.
    # - rdoc-ref:MetalArchives::Errors::NotFoundError when receiving status code 404
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving status code >= 400
    #
    attribute :notes

    protected

    ##
    # Fetch the data and assemble the model
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::ParserError when parsing failed. Please report this error.
    # - rdoc-ref:MetalArchives::Errors::NotFoundError when receiving status code 404
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving status code >= 400
    #
    def assemble # :nodoc:
      ## Base attributes
      response = MetalArchives.http.get "/albums/view/id/#{id}"

      Parsers::Release.parse_html response.to_s
    end

    class << self
      ##
      # Find by attributes
      #
      # Refer to {MA's FAQ}[http://www.metal-archives.com/content/help?index=3#tab_db] for search tips.
      #
      # Returns rdoc-ref:Release or nil when no results
      #
      # [Raises]
      # - rdoc-ref:MetalArchives::Errors::ParserError when parsing failed. Please report this error.
      # - rdoc-ref:MetalArchives::Errors::NotFoundError when receiving status code 404
      # - rdoc-ref:MetalArchives::Errors::APIError when receiving status code >= 400
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

        response = MetalArchives.http.get "/search/ajax-advanced/searching/albums", params
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
      # - rdoc-ref:MetalArchives::Errors::ParserError when parsing failed. Please report this error.
      # - rdoc-ref:MetalArchives::Errors::NotFoundError when receiving status code 404
      # - rdoc-ref:MetalArchives::Errors::APIError when receiving status code >= 400
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
      # - rdoc-ref:MetalArchives::Errors::ParserError when parsing failed. Please report this error.
      # - rdoc-ref:MetalArchives::Errors::APIError when receiving status code >= 400
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
            response = MetalArchives.http.get "/search/ajax-advanced/searching/albums", params.merge(iDisplayStart: @start)
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
      # - rdoc-ref:MetalArchives::Errors::ParserError when parsing failed. Please report this error.
      # - rdoc-ref:MetalArchives::Errors::APIError when receiving status code >= 400
      #
      # [+title+]
      #     +String+
      #
      def search(title)
        search_by(title: title.to_s)
      end

      ##
      # Get all releases
      #
      # Returns rdoc-ref:Collection of rdoc-ref:Release
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
