require 'date'
require 'countries'

module MetalArchives

  ##
  # Represents an band (person or group)
  #
  class Band < BaseModel
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
    property :name

    ##
    # :attr_reader: aliases
    #
    # Returns +Array+ of +String+
    #
    property :aliases, :multiple => true

    ##
    # :attr_reader: country
    #
    # Returns +ISO3166::Country+
    #
    property :country, :type => ISO3166::Country

    ##
    # :attr_reader: location
    #
    # Returns +String+
    #
    property :location

    ##
    # :attr_reader: date_formed
    #
    # Returns +Date+
    #
    property :date_formed, :type => Date

    ##
    # :attr_reader: date_active
    #
    # Returns +Array+ of rdoc-ref:Range
    #
    property :date_active, :type => MetalArchives::Range, :multiple => true

    ##
    # :attr_reader: genres
    #
    # Returns +Array+ of +String+
    #
    property :genres, :multiple => true

    ##
    # :attr_reader: lyrical_themes
    #
    # Returns +Array+ of +String+
    #
    property :lyrical_themes, :multiple => true

    ##
    # :attr_reader: label
    #
    # Returns rdoc-ref:Label
    #
    property :label, :type => MetalArchives::Label

    ##
    # :attr_reader: independent
    #
    # Returns boolean
    #
    enum :independent, :values => [true, false]

    ##
    # :attr_reader: comment
    #
    # Returns +String+
    #
    property :comment

    ##
    # :attr_reader: status
    #
    # Returns +:active+, +:split_up+, +:on_hold+, +:unknown+, +:changed_name+ or +:disputed+
    #
    enum :status, :values => [:active, :split_up, :on_hold, :unknown, :changed_name, :disputed]

    # TODO: releases
    # TODO: members
    # TODO: reviews

    ##
    # :attr_reader: similar
    #
    # Returns +Array+ of +Hash+ containing the following keys
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
    property :logo

    ##
    # :attr_reader: photo
    #
    # Returns +String+
    #
    property :photo

    ##
    # :attr_reader: links
    #
    # Returns +Array+ of +Hash+ containing the following keys
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
      # Raises rdoc-ref:MetalArchives::Errors::APIError
      #
      def assemble # :nodoc:
        ## Base attributes
        url = "http://www.metal-archives.com/band/view/id/#{id}"
        response = HTTPClient.client.get url
        raise Errors::APIError, response.status if response.status >= 400

        properties = Parsers::Band.parse_html response.body

        ## Similar artists
        url = "http://www.metal-archives.com/band/ajax-recommendations/id/#{id}"
        response = HTTPClient.client.get url
        raise Errors::APIError, response.status if response.status >= 400

        properties[:similar] = Parsers::Band.parse_similar_bands_html response.body

        ## Related links
        url = "http://www.metal-archives.com/link/ajax-list/type/band/id/#{id}"
        response = HTTPClient.client.get url
        raise Errors::APIError, response.status if response.status >= 400

        properties[:links] = Parsers::Band.parse_related_links_html response.body

        ## Use constructor to fill properties
        initialize properties
      end

    class << self
      ##
      # Find by ID
      #
      # Refer to {MA's FAQ}[http://www.metal-archives.com/content/help?index=3#tab_db] for search tips.
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
      # Find by attributes
      #
      # Refer to {MA's FAQ}[http://www.metal-archives.com/content/help?index=3#tab_db] for search tips.
      #
      # Returns rdoc-ref:Band or nil when ID is invalid
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
        url = "http://www.metal-archives.com/search/ajax-advanced/searching/bands/"
        params = Parsers::Band.map_params query

        response = HTTPClient.client.get url, params
        raise Errors::APIError, response.status if response.status >= 400

        json = Parsers::Band.parse_json response.body

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
      # Returns (possibly empty) +Array+ of rdoc-ref:Band
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
        url = "http://www.metal-archives.com/search/ajax-advanced/searching/bands/"
        params = Parsers::Band.map_params query

        response = HTTPClient.client.get url, params
        raise Errors::APIError, response.status if response.status >= 400

        json = Parsers::Band.parse_json response.body

        objects = []
        json['aaData'].each do |data|
          # Fetch Band for every ID in the results list
          id = Nokogiri::HTML(data.first).xpath('//a/@href').first.value.gsub('\\', '').split('/').last.gsub(/\D/, '').to_i
          objects << Band.new(:id => id)
        end

        objects
      end

      ##
      # Search by name, resolves to rdoc-ref:Band.search_by <tt>(:name => name)</tt>
      #
      # Refer to {MA's FAQ}[http://www.metal-archives.com/content/help?index=3#tab_db] for search tips.
      #
      # Returns (possibly empty) +Array+ of rdoc-ref:Band
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
