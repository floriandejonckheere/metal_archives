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

        MetalArchives.Collection(Artist).new("/search/ajax-advanced/searching/albums", params)
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

      TYPE_TO_QUERY = {
        full_length: 1,
        live: 2,
        demo: 3,
        single: 4,
        ep: 5,
        video: 6,
        boxed_set: 7,
        split: 8,
        compilation: 10,
        split_video: 12,
        collaboration: 13,
      }.freeze

      TYPE_TO_SYM = {
        "Full-length" => :full_length,
        "Live album" => :live,
        "Demo" => :demo,
        "Single" => :single,
        "EP" => :ep,
        "Video" => :video,
        "Boxed set" => :boxed_set,
        "Split" => :split,
        "Compilation" => :compilation,
        "Split video" => :split_video,
        "Collaboration" => :collaboration,
      }.freeze

      FORMAT_TO_QUERY = {
        cd: "CD",
        cassette: "Cassette",
        vinyl: "Vinyl*",
        vhs: "VHS",
        dvd: "DVD",
        "2dvd": "2DVD",
        digital: "Digital",
        blu_ray: "Blu-ray*",
        other: "Other",
        unknown: "Unknown",
      }.freeze

      FORMAT_TO_SYM = {
        "CD" => :cd,
        "Cassette" => :cassette,
        "VHS" => :vhs,
        "DVD" => :dvd,
        "2DVD" => :"2dvd",
        "Digital" => :digital,
        "Other" => :other,
        "Unknown" => :unknown,
      }.freeze

      ##
      # Map attributes to MA attributes
      #
      # Returns +Hash+
      #
      # [+params+]
      #     +Hash+
      #
      def map_params(query)
        {
          bandName: query[:band_name] || "",
          releaseTitle: query[:title] || "",
          releaseYearFrom: query[:from_year] || "",
          releaseMonthFrom: query[:from_month] || "",
          releaseYearTo: query[:to_year] || "",
          releaseMonthTo: query[:to_month] || "",
          country: map_countries(query[:country]) || "",
          location: query[:location] || "",
          releaseLabelName: query[:label_name] || "",
          releaseCatalogNumber: query[:catalog_id] || "",
          releaseIdentifiers: query[:identifier] || "",
          releaseRecordingInfo: query[:recording_info] || "",
          releaseDescription: query[:version_description] || "",
          releaseNotes: query[:notes] || "",
          genre: query[:genre] || "",
          releaseType: map_types(query[:types]),
          releaseFormat: map_formats(query[:formats]),
        }
      end

      ##
      # Map MA release type to query parameters
      #
      # Returns +Array+ of +Integer+
      #
      # [+types+]
      #     +Array+ containing one or more +Symbol+, see rdoc-ref:Release.type
      #
      def map_types(type_syms)
        return unless type_syms

        types = []
        type_syms.each do |type|
          raise Errors::ParserError, "Unknown type: #{type}" unless TYPE_TO_QUERY[type]

          types << TYPE_TO_QUERY[type]
        end

        types
      end

      ##
      # Map MA release type to +Symbol+
      #
      # Returns +Symbol+, see rdoc-ref:Release.type
      #
      def map_type(type)
        raise Errors::ParserError, "Unknown type: #{type}" unless TYPE_TO_SYM[type]

        TYPE_TO_SYM[type]
      end

      ##
      # Map MA release format to query parameters
      #
      # Returns +Array+ of +Integer+
      #
      # [+types+]
      #     +Array+ containing one or more +Symbol+, see rdoc-ref:Release.type
      #
      def map_formats(format_syms)
        return unless format_syms

        formats = []
        format_syms.each do |format|
          raise Errors::ParserError, "Unknown format: #{format}" unless FORMAT_TO_QUERY[format]

          formats << FORMAT_TO_QUERY[format]
        end

        formats
      end
    end
  end
end
