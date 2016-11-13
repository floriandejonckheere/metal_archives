require 'date'
require 'countries'

module MetalArchives

  ##
  # Represents an band (person or group)
  #
  class Band < MetalArchives::BaseModel
    ##
    # :attr_reader: id
    #
    # Returns +Integer+
    #
    property :id, :type => Integer

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
    property :aliases, :multiple => true

    ##
    # :attr_reader: country
    #
    # Returns +ISO3166::Country+
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::InvalidIDError when no or invalid id
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving a status code >= 400 (except 404)
    #
    property :country, :type => ISO3166::Country

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
    # :attr_reader: date_formed
    #
    # Returns +Date+
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::InvalidIDError when no or invalid id
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving a status code >= 400 (except 404)
    #
    property :date_formed, :type => Date

    ##
    # :attr_reader: date_active
    #
    # Returns +Array+ of rdoc-ref:Range
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::InvalidIDError when no or invalid id
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving a status code >= 400 (except 404)
    #
    property :date_active, :type => MetalArchives::Range, :multiple => true

    ##
    # :attr_reader: genres
    #
    # Returns +Array+ of +String+
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::InvalidIDError when no or invalid id
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving a status code >= 400 (except 404)
    #
    property :genres, :multiple => true

    ##
    # :attr_reader: lyrical_themes
    #
    # Returns +Array+ of +String+
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::InvalidIDError when no or invalid id
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving a status code >= 400 (except 404)
    #
    property :lyrical_themes, :multiple => true

    ##
    # :attr_reader: label
    #
    # Returns rdoc-ref:Label
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::InvalidIDError when no or invalid id
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving a status code >= 400 (except 404)
    #
    property :label, :type => MetalArchives::Label

    ##
    # :attr_reader: independent
    #
    # Returns boolean
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::InvalidIDError when no or invalid id
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving a status code >= 400 (except 404)
    #
    enum :independent, :values => [true, false]

    ##
    # :attr_reader: comment
    #
    # Returns raw HTML +String+
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::InvalidIDError when no or invalid id
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving a status code >= 400 (except 404)
    #
    property :comment

    ##
    # :attr_reader: status
    #
    # Returns +:active+, +:split_up+, +:on_hold+, +:unknown+, +:changed_name+ or +:disputed+
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::InvalidIDError when no or invalid id
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving a status code >= 400 (except 404)
    #
    enum :status, :values => [:active, :split_up, :on_hold, :unknown, :changed_name, :disputed]

    # TODO: releases
    # TODO: members

    ##
    # :attr_reader: similar
    #
    # Returns +Array+ of +Hash+ containing the following keys
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::InvalidIDError when no or invalid id
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving a status code >= 400 (except 404)
    #
    # [+similar+]
    #     - +:band+: rdoc-ref:Band
    #     - +:score+: +Integer+
    #
    property :similar, :type => Hash, :multiple => true

    ##
    # :attr_reader: logo
    #
    # Returns +String+
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::InvalidIDError when no or invalid id
    # - rdoc-ref:MetalArchives::Errors::APIError when receiving a status code >= 400 (except 404)
    #
    property :logo

    ##
    # :attr_reader: photo
    #
    # Returns +String+
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
    # [+similar+]
    #     - +:url+: +String+
    #     - +:type+: +Symbol+, either +:official+ or +:merchandise+
    #     - +:title+: +String+
    #
    property :links, :multiple => true

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
        url = "http://www.metal-archives.com/band/view/id/#{id}"
        response = HTTPClient.get url

        properties = Parsers::Band.parse_html response.body

        ## Comment
        url = "http://www.metal-archives.com/band/read-more/id/#{id}"
        response = HTTPClient.get url

        properties[:comment] = response.body

        ## Similar artists
        url = "http://www.metal-archives.com/band/ajax-recommendations/id/#{id}"
        response = HTTPClient.get url

        properties[:similar] = Parsers::Band.parse_similar_bands_html response.body

        ## Related links
        url = "http://www.metal-archives.com/link/ajax-list/type/band/id/#{id}"
        response = HTTPClient.get url

        properties[:links] = Parsers::Band.parse_related_links_html response.body

        properties
      end

    class << self
      ##
      # Find by ID
      #
      # Returns rdoc-ref:Band, even when ID is invalid (because the data is lazily fetched)
      #
      # [+id+]
      #     +Integer+
      #
      def find(id)
        Band.new :id => id
      end

      ##
      # Find by ID (no lazy loading)
      #
      # Returns rdoc-ref:Band
      #
      # [Raises]
      # - rdoc-ref:MetalArchives::Errors::InvalidIDError when no or invalid id
      # - rdoc-ref:MetalArchives::Errors::APIError when receiving a status code >= 400 (except 404)
      #
      # [+id+]
      #     +Integer+
      #
      def find!(id)
        obj = find id
        obj.send :fetch

        obj
      end

      ##
      # Find by attributes
      #
      # Refer to {MA's FAQ}[http://www.metal-archives.com/content/help?index=3#tab_db] for search tips.
      #
      # Returns rdoc-ref:Band or nil when no results
      #
      # [Raises]
      # - rdoc-ref:MetalArchives::Errors::APIError when receiving a status code >= 400
      #
      # [+query+]
      #     Hash containing one or more of the following keys:
      #     - +:name+: +String+
      #     - +:exact+: +Boolean+
      #     - +:genre+: +String+
      #     - +:country+: +ISO366::Country+
      #     - +:year_formation+: rdoc-ref:Range of +Date+
      #     - +:comment+: +String+
      #     - +:status+: see rdoc-ref:Band.status
      #     - +:lyrical_themes+: +String+
      #     - +:location+: +String+
      #     - +:label+: rdoc-ref:Label
      #     - +:independent+: boolean
      #
      def find_by(query)
        url = 'http://www.metal-archives.com/search/ajax-advanced/searching/bands/'
        params = Parsers::Band.map_params query

        response = HTTPClient.get url, params
        json = JSON.parse response.body

        return nil if json['aaData'].empty?

        data = json['aaData'].first
        id = Nokogiri::HTML(data.first).xpath('//a/@href').first.value.gsub('\\', '').split('/').last.gsub(/\D/, '').to_i

        Band.new :id => id
      rescue Errors::APIError
        nil
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
      #
      # [+query+]
      #     Hash containing one or more of the following keys:
      #     - +:name+: +String+
      #     - +:exact+: +Boolean+
      #     - +:genre+: +String+
      #     - +:country+: +ISO366::Country+
      #     - +:year_formation+: rdoc-ref:Range of +Date+
      #     - +:comment+: +String+
      #     - +:status+: see rdoc-ref:Band.status
      #     - +:lyrical_themes+: +String+
      #     - +:location+: +String+
      #     - +:label+: rdoc-ref:Label
      #     - +:independent+: boolean
      #
      def search_by(query)
        url = 'http://www.metal-archives.com/search/ajax-advanced/searching/bands/'

        params = Parsers::Band.map_params query

        l = lambda do
          @start ||= 0

          return [] if instance_variable_defined?('@max_items') and @start >= @max_items

          response = HTTPClient.get url, params.merge(:iDisplayStart => @start)
          json = JSON.parse response.body

          @max_items = json['iTotalRecords']

          objects = []

          json['aaData'].each do |data|
            # Create Band object for every ID in the results list
            id = Nokogiri::HTML(data.first).xpath('//a/@href').first.value.gsub('\\', '').split('/').last.gsub(/\D/, '').to_i
            objects << Band.new(:id => id)
          end

          @start += 200

          objects
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
      #
      # [+name+]
      #     +String+
      #
      def search(name)
        search_by :name => name
      end
    end
  end
end
