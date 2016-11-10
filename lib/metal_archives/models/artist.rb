require 'date'
require 'countries'

module MetalArchives

  ##
  # Represents a single performer (but not a solo artist)
  #
  class Artist < BaseModel
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
    # :attr_reader: date_of_birth
    #
    # Returns +Date+
    #
    property :date_of_birth, :type => Date

    ##
    # :attr_reader: gender
    #
    # Returns +Symbol+, either +:male+ or +:female+
    #
    enum :gender, :values => [:male, :female]

    ##
    # :attr_reader: biography
    #
    # Returns +String+
    #
    property :biography

    ##
    # :attr_reader: trivia
    #
    # Returns +String+
    #
    property :trivia

    # TODO: active bands/albums
    # TODO: past bands/albums
    # TODO: guest bands/albums
    # TODO: misc bands/albums
    # TODO: links

    protected
    ##
    # Fetch the data and assemble the model
    #
    # Raises rdoc-ref:MetalArchives::Errors::APIError
    #
    def assemble # :nodoc:
      ## Base attributes
      url = "http://www.metal-archives.com/artist/view/id/#{id}"
      response = HTTPClient.get url

      properties = Parsers::Artist.parse_html response.body

      ## Use constructor to fill properties
      initialize properties
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
        Artist.new :id => id
      end

      ##
      # Find by attributes
      #
      # Returns rdoc-ref:Artist or nil when ID is invalid
      #
      # [+query+]
      #     Hash containing one or more of the following keys:
      #     - +:name+: +String+
      #
      def find_by(query)
        url = 'http://www.metal-archives.com/search/ajax-artist-search/'
        params = Parsers::Artist.map_params query

        response = HTTPClient.get url, params
        json = JSON.parse response.body

        return nil if json['aaData'].empty?

        data = json['aaData'].first
        id = Nokogiri::HTML(data.first).xpath('//a/@href').first.value.gsub('\\', '').split('/').last.gsub(/\D/, '').to_i

        Artist.new :id => id
      rescue Errors::APIError
        nil
      end

      ##
      # Search by name
      #
      # Returns (possibly empty) +Array+ of rdoc-ref:Artist
      #
      # [+name+]
      #     +String+
      #
      def search(name)
        url = "http://www.metal-archives.com/search/ajax-artist-search/"
        params = Parsers::Artist.map_params :name => name

        response = HTTPClient.get url, params
        json = JSON.parse response.body

        objects = []
        json['aaData'].each do |data|
          # Fetch Band for every ID in the results list
          id = Nokogiri::HTML(data.first).xpath('//a/@href').first.value.gsub('\\', '').split('/').last.gsub(/\D/, '').to_i
          objects << Artist.new(:id => id)
        end

        objects
      end
    end
  end
end
