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
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving a status code >= 400 (except 404)
    #
    attribute :name

    ##
    # :attr_reader: aliases
    #
    # [Returns]
    # - +Array+ of +String+
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving a status code >= 400 (except 404)
    #
    attribute :aliases, multiple: true

    ##
    # :attr_reader: country
    #
    # [Returns]
    # - +ISO3166::Country+
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving a status code >= 400 (except 404)
    #
    attribute :country, type: :country

    ##
    # :attr_reader: location
    #
    # [Returns]
    # - +String+
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving a status code >= 400 (except 404)
    #
    attribute :location

    ##
    # :attr_reader: date_formed
    #
    # [Returns]
    # - +Date+
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving a status code >= 400 (except 404)
    #
    attribute :date_formed, type: :date

    ##
    # :attr_reader: years_active
    #
    # [Returns]
    # - +Array+ of rdoc-ref:Range containing +Integer+
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving a status code >= 400 (except 404)
    #
    attribute :years_active, type: :range, multiple: true

    ##
    # :attr_reader: genres
    #
    # [Returns]
    # - +Array+ of +String+
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving a status code >= 400 (except 404)
    #
    attribute :genres, multiple: true

    ##
    # :attr_reader: lyrical_themes
    #
    # [Returns]
    # - +Array+ of +String+
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving a status code >= 400 (except 404)
    #
    attribute :lyrical_themes, multiple: true

    ##
    # :attr_reader: label
    #
    # [Returns]
    # - rdoc-ref:Label
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving a status code >= 400 (except 404)
    #
    attribute :label, type: :label

    ##
    # :attr_reader: independent
    #
    # [Returns]
    # - +Boolean+
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving a status code >= 400 (except 404)
    #
    attribute :independent, type: :boolean

    ##
    # :attr_reader: comment
    #
    # [Returns]
    # - raw HTML +String+
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving a status code >= 400 (except 404)
    #
    attribute :comment

    ##
    # :attr_reader: status
    #
    # [Returns]
    # - +Symbol+, one of +:active+, +:split_up+, +:on_hold+, +:unknown+, +:changed_name+ or +:disputed+
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
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving a status code >= 400 (except 404)
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
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving a status code >= 400 (except 404)
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
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving a status code >= 400 (except 404)
    #
    attribute :similar, type: :hash, multiple: true

    ##
    # :attr_reader: logo
    #
    # [Returns]
    # - +URI+ (rewritten if config option was enabled)
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving a status code >= 400 (except 404)
    #
    attribute :logo, type: :uri

    ##
    # :attr_reader: photo
    #
    # [Returns]
    # - +URI+ (rewritten if config option was enabled)
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving a status code >= 400 (except 404)
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
    # - rdoc-ref:MetalArchives::Errors::InvalidIDError when no or invalid id
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving a status code >= 400 (except 404)
    #
    attribute :links, type: :hash, multiple: true

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
      response = MetalArchives.http.get "/band/view/id/#{id}"

      properties = Parsers::Band.parse_html response.to_s

      ## Comment
      response = MetalArchives.http.get "/band/read-more/id/#{id}"

      properties[:comment] = response.to_s

      ## Similar artists
      response = MetalArchives.http.get "/band/ajax-recommendations/id/#{id}"

      properties[:similar] = Parsers::Band.parse_similar_bands_html response.to_s

      ## Related links
      response = MetalArchives.http.get "/link/ajax-list/type/band/id/#{id}"

      properties[:links] = Parsers::Band.parse_related_links_html response.to_s

      ## Releases
      response = MetalArchives.http.get "/band/discography/id/#{id}/tab/all"

      properties[:releases] = Parsers::Band.parse_releases_html response.to_s

      properties
    end

    class << self
      ##
      # Find by attributes
      #
      # Refer to {MA's FAQ}[http://www.metal-archives.com/content/help?index=3#tab_db] for search tips.
      #
      # Returns rdoc-ref:Band or nil when no results
      #
      # [Raises]
      # - rdoc-ref:MetalArchives::Errors::APIError when receiving a status code >= 400
      # - rdoc-ref:MetalArchives::Errors::ParserError when parsing failed. Please report this error.
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
        params = Parsers::Band.map_params query

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
      # - rdoc-ref:MetalArchives::Errors::APIError when receiving a status code >= 400
      # - rdoc-ref:MetalArchives::Errors::ParserError when parsing failed. Please report this error.
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
      # - rdoc-ref:MetalArchives::Errors::APIError when receiving a status code >= 400
      # - rdoc-ref:MetalArchives::Errors::ParserError when parsing failed. Please report this error.
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
        params = Parsers::Band.map_params query

        l = lambda do
          @start ||= 0

          if @max_items && @start >= @max_items
            []
          else
            response = MetalArchives.http.get "/search/ajax-advanced/searching/bands", params.merge(iDisplayStart: @start)
            json = JSON.parse response.to_s

            @max_items = json["iTotalRecords"]

            objects = []

            json["aaData"].each do |data|
              # Create Band object for every ID in the results list
              id = Nokogiri::HTML(data.first).xpath("//a/@href").first.value.delete('\\').split("/").last.gsub(/\D/, "").to_i
              objects << Band.find(id)
            end

            @start += 200

            objects
          end
        end

        MetalArchives::Collection.new l
      end

      ##
      # Search by name, resolves to rdoc-ref:Band.search_by <tt>(:name => name)</tt>
      #
      # Refer to {MA's FAQ}[http://www.metal-archives.com/content/help?index=3#tab_db] for search tips.
      #
      # Returns (possibly empty) +Array+ of rdoc-ref:Band
      #
      # [Raises]
      # - rdoc-ref:MetalArchives::Errors::APIError when receiving a status code >= 400
      # - rdoc-ref:MetalArchives::Errors::ArgumentError when +name+ isn't a +String+
      #
      # [+name+]
      #     +String+
      #
      def search(name)
        raise MetalArchives::Errors::ArgumentError unless name.is_a? String

        search_by name: name
      end

      ##
      # Get all bands
      #
      # Returns rdoc-ref:Collection of rdoc-ref:Band
      #
      # [Raises]
      # - rdoc-ref:MetalArchives::Errors::APIError when receiving a status code >= 400
      # - rdoc-ref:MetalArchives::Errors::ParserError when parsing failed. Please report this error.
      #
      def all
        search_by({})
      end
    end
  end
end
