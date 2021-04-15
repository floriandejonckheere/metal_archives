# frozen_string_literal: true

module MetalArchives
  ##
  # Represents a band (person or group)
  #
  class Band < Base
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
    # :attr_reader: date_formed
    #
    # [Returns]
    # - +Date+
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::ParserError when parsing failed. Please report this error.
    # - rdoc-ref:MetalArchives::Errors::NotFoundError when receiving status code 404
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving status code >= 400
    #
    attribute :date_formed, type: :date

    ##
    # :attr_reader: years_active
    #
    # [Returns]
    # - +Array+ of rdoc-ref:Range containing +Integer+
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::ParserError when parsing failed. Please report this error.
    # - rdoc-ref:MetalArchives::Errors::NotFoundError when receiving status code 404
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving status code >= 400
    #
    attribute :years_active, type: :range, multiple: true

    ##
    # :attr_reader: genres
    #
    # [Returns]
    # - +Array+ of +String+
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::ParserError when parsing failed. Please report this error.
    # - rdoc-ref:MetalArchives::Errors::NotFoundError when receiving status code 404
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving status code >= 400
    #
    attribute :genres, multiple: true

    ##
    # :attr_reader: lyrical_themes
    #
    # [Returns]
    # - +Array+ of +String+
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::ParserError when parsing failed. Please report this error.
    # - rdoc-ref:MetalArchives::Errors::NotFoundError when receiving status code 404
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving status code >= 400
    #
    attribute :lyrical_themes, multiple: true

    ##
    # :attr_reader: label
    #
    # [Returns]
    # - rdoc-ref:Label
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::ParserError when parsing failed. Please report this error.
    # - rdoc-ref:MetalArchives::Errors::NotFoundError when receiving status code 404
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving status code >= 400
    #
    attribute :label, type: :label

    ##
    # :attr_reader: independent
    #
    # [Returns]
    # - +Boolean+
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::ParserError when parsing failed. Please report this error.
    # - rdoc-ref:MetalArchives::Errors::NotFoundError when receiving status code 404
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving status code >= 400
    #
    attribute :independent, type: :boolean

    ##
    # :attr_reader: comment
    #
    # [Returns]
    # - raw HTML +String+
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::ParserError when parsing failed. Please report this error.
    # - rdoc-ref:MetalArchives::Errors::NotFoundError when receiving status code 404
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving status code >= 400
    #
    attribute :comment

    ##
    # :attr_reader: status
    #
    # [Returns]
    # - rdoc-ref:MetalArchives::Errors::ParserError when parsing failed. Please report this error.
    # - rdoc-ref:MetalArchives::Errors::NotFoundError when receiving status code 404
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving status code >= 400
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving a status code >= 400 (except 404)
    #
    attribute :status, type: :symbol, enum: [:active, :split_up, :on_hold, :unknown, :changed_name, :disputed]

    ##
    # :attr_reader: releases
    #
    # [Returns]
    # - +Array+ of rdoc-ref:Release
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::ParserError when parsing failed. Please report this error.
    # - rdoc-ref:MetalArchives::Errors::NotFoundError when receiving status code 404
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving status code >= 400
    #
    attribute :releases, type: :release, multiple: true

    ##
    # :attr_reader: members
    #
    # [Returns]
    # - +Array+ of +Hash+ containing the following keys
    #
    # [+members+]
    #   - +:artist+: rdoc-ref:Artist
    #   - +:current+: Boolean
    #   - +:years_active+: +Array+ of rdoc-ref:Range containing +Integer+
    #   - +:role+: +String+
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::ParserError when parsing failed. Please report this error.
    # - rdoc-ref:MetalArchives::Errors::NotFoundError when receiving status code 404
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving status code >= 400
    #
    attribute :members, type: :hash, multiple: true

    ##
    # :attr_reader: similar
    #
    # [Returns]
    # - +Array+ of +Hash+ containing the following keys
    #
    # [+similar+]
    #   - +:band+: rdoc-ref:Band
    #   - +:score+: +Integer+
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::ParserError when parsing failed. Please report this error.
    # - rdoc-ref:MetalArchives::Errors::NotFoundError when receiving status code 404
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving status code >= 400
    #
    attribute :similar, type: :hash, multiple: true

    ##
    # :attr_reader: logo
    #
    # [Returns]
    # - +URI+ (rewritten if config option was enabled)
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::ParserError when parsing failed. Please report this error.
    # - rdoc-ref:MetalArchives::Errors::NotFoundError when receiving status code 404
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving status code >= 400
    #
    attribute :logo, type: :uri

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
    # - +Array+ of +Hash+ containing the following keys
    #
    # [+links+]
    #   - +:url+: +String+
    #   - +:type+: +Symbol+, either +:official+ or +:merchandise+
    #   - +:title+: +String+
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::ParserError when parsing failed. Please report this error.
    # - rdoc-ref:MetalArchives::Errors::NotFoundError when receiving status code 404
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving status code >= 400
    #
    attribute :links, type: :hash, multiple: true

    class << self
      ##
      # Find by attributes
      #
      # Refer to {MA's FAQ}[http://www.metal-archives.com/content/help?index=3#tab_db] for search tips.
      #
      # Returns rdoc-ref:Band or nil when no results
      #
      # [Raises]
      # - rdoc-ref:MetalArchives::Errors::ParserError when parsing failed. Please report this error.
      # - rdoc-ref:MetalArchives::Errors::NotFoundError when receiving status code 404
      # - rdoc-ref:MetalArchives::Errors::APIError when receiving status code >= 400
      #
      # [+query+]
      #     Hash containing one or more of the following keys:
      #     - +:name+: +String+
      #     - +:exact+: +Boolean+
      #     - +:genre+: +String+
      #     - +:country+: +ISO3166::Country+
      #     - +:year_formation+: rdoc-ref:Range containing rdoc-ref:Date
      #     - +:comment+: +String+
      #     - +:status+: see rdoc-ref:Band.status
      #     - +:lyrical_themes+: +String+
      #     - +:location+: +String+
      #     - +:label+: rdoc-ref:Label
      #     - +:independent+: boolean
      #
      def find_by(query)
        params = map_params query

        response = MetalArchives.http.get "/search/ajax-advanced/searching/bands", params
        json = JSON.parse response.to_s

        return nil if json["aaData"].empty?

        data = json["aaData"].first
        id = Nokogiri::HTML(data.first).xpath("//a/@href").first.value.delete('\\').split("/").last.gsub(/\D/, "").to_i

        find id
      end

      ##
      # Find by attributes (no lazy loading)
      #
      # Refer to {MA's FAQ}[http://www.metal-archives.com/content/help?index=3#tab_db] for search tips.
      #
      # Returns rdoc-ref:Band or nil when no results
      #
      # [Raises]
      # - rdoc-ref:MetalArchives::Errors::ParserError when parsing failed. Please report this error.
      # - rdoc-ref:MetalArchives::Errors::NotFoundError when receiving status code 404
      # - rdoc-ref:MetalArchives::Errors::APIError when receiving status code >= 400
      #
      # [+query+]
      #     Hash containing one or more of the following keys:
      #     - +:name+: +String+
      #     - +:exact+: +Boolean+
      #     - +:genre+: +String+
      #     - +:country+: +ISO3166::Country+
      #     - +:year_formation+: rdoc-ref:Range containing rdoc-ref:Date
      #     - +:comment+: +String+
      #     - +:status+: see rdoc-ref:Band.status
      #     - +:lyrical_themes+: +String+
      #     - +:location+: +String+
      #     - +:label+: rdoc-ref:Label
      #     - +:independent+: boolean
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
      # Returns rdoc-ref:Collection of rdoc-ref:Band
      #
      # [Raises]
      # - rdoc-ref:MetalArchives::Errors::ParserError when parsing failed. Please report this error.
      # - rdoc-ref:MetalArchives::Errors::APIError when receiving status code >= 400
      #
      # [+query+]
      #     Hash containing one or more of the following keys:
      #     - +:name+: +String+
      #     - +:exact+: +Boolean+
      #     - +:genre+: +String+
      #     - +:country+: +ISO3166::Country+
      #     - +:year_formation+: rdoc-ref:Range containing rdoc-ref:Date
      #     - +:comment+: +String+
      #     - +:status+: see rdoc-ref:Band.status
      #     - +:lyrical_themes+: +String+
      #     - +:location+: +String+
      #     - +:label+: rdoc-ref:Label
      #     - +:independent+: boolean
      #
      def search_by(query)
        params = map_params query

        MetalArchives.Collection(Artist).new("/search/ajax-advanced/searching/bands", params)
      end

      ##
      # Search by name, resolves to rdoc-ref:Band.search_by <tt>(:name => name)</tt>
      #
      # Refer to {MA's FAQ}[http://www.metal-archives.com/content/help?index=3#tab_db] for search tips.
      #
      # Returns (possibly empty) +Array+ of rdoc-ref:Band
      #
      # [Raises]
      # - rdoc-ref:MetalArchives::Errors::ParserError when parsing failed. Please report this error.
      # - rdoc-ref:MetalArchives::Errors::APIError when receiving status code >= 400
      #
      # [+name+]
      #     +String+
      #
      def search(name)
        search_by(name: name.to_s)
      end

      ##
      # Get all bands
      #
      # Returns rdoc-ref:Collection of rdoc-ref:Band
      #
      # [Raises]
      # - rdoc-ref:MetalArchives::Errors::ParserError when parsing failed. Please report this error.
      # - rdoc-ref:MetalArchives::Errors::APIError when receiving status code >= 400
      #
      def all
        search_by({})
      end

      ##
      # Map attributes to MA attributes
      #
      # Returns +Hash+
      #
      # [+params+]
      #     +Hash+
      #
      def map_params(query)
        params = {
          bandName: query[:name] || "",
          exactBandMatch: (query[:exact] ? 1 : 0),
          genre: query[:genre] || "",
          yearCreationFrom: query[:year]&.begin || "",
          yearCreationTo: query[:year]&.end || "",
          bandNotes: query[:comment] || "",
          status: map_status(query[:status]),
          themes: query[:lyrical_themes] || "",
          location: query[:location] || "",
          bandLabelName: query[:label] || "",
          indieLabelBand: (query[:independent] ? 1 : 0),
        }

        params[:country] = []
        Array(query[:country]).each do |country|
          params[:country] << (country.is_a?(ISO3166::Country) ? country.alpha2 : (country || ""))
        end
        params[:country] = params[:country].first if params[:country].size == 1

        params
      end

      ##
      # Map MA band status
      #
      # Returns +Symbol+
      #
      # [Raises]
      # - rdoc-ref:MetalArchives::Errors::ParserError when parsing failed. Please report this error.
      #
      def map_status(status)
        s = {
          nil => "",
          :active => "Active",
          :split_up => "Split-up",
          :on_hold => "On hold",
          :unknown => "Unknown",
          :changed_name => "Changed name",
          :disputed => "Disputed",
        }

        raise Errors::ParserError, "Unknown status: #{status}" unless s[status]

        s[status]
      end
    end
  end
end
