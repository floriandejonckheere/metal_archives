require 'faraday'

module MetalArchives
  class << self
    ##
    # Retrieve a rdoc-ref:Client instance
    #
    def client
      @client ||= Client.new
    end
  end
  ##
  # HTTP request client
  #
  class Client
    ##
    # Find a +model+ using +query+
    #
    # [+model+]
    #     +Symbol+ representing a class < rdoc-ref:BaseModel
    #
    # [+query+]
    #     +Hash+ containing query parameters
    #
    # Raises rdoc-ref:MetalArchives::Errors::APIError on error
    #
    def find_by(model, query)
      parser = resolve_parser model

      url = parser.search_endpoint query
      params = parser.map_params query

      response = http.get url, params
      raise MetalArchives::Errors::APIError, response.status if response.status > 400

      object = MetalArchives.const_get(model.to_s.capitalize).new parser.parse_json response.body

      object
    end

    ##
    # Find multiple +model+s using +query+
    #
    # [+model+]
    #     +Symbol+ representing a class < rdoc-ref:BaseModel
    #
    # [+query+]
    #     +Hash+ containing query parameters
    #
    # Returns +Array+
    #
    # Raises rdoc-ref:MetalArchives::Errors::APIError on error
    #
    def search_by(model, query)
      parser = resolve_parser model

      url = parser.search_endpoint query
      params = parser.map_params query

      response = http.get url, params
      raise MetalArchives::Errors::APIError, response.status if response.status > 400

      json = parser.parse_json response.body

      objects = []
      json['aaData'].each do |data|
        object = {
          :name => Nokogiri::HTML(data[0]).xpath("//text()").to_s.strip,
          :genres => MetalArchives::Parsers::ParserHelper.parse_genre(data[1]),
          :country => ISO3166::Country.find_country_by_name(data[2])
        }
        objects << MetalArchives.const_get(model.to_s.capitalize).new(object)
      end

      objects
    end

    ##
    # Find a +model+ using ID
    #
    # [+model+]
    #     +Symbol+ representing a class < rdoc-ref:BaseModel
    #
    # [+id+]
    #     +Integer+
    #
    def find_by_id(model, id)
      parser = resolve_parser model

      url = parser.find_endpoint :id => id

      response = http.get url
      return nil if response.status > 400
      object = MetalArchives.const_get(model.to_s.capitalize).new parser.parse_html response.body

      object
    end

    private
      ##
      # Get a http client
      #
      def http
        raise MetalArchives::Errors::InvalidConfigurationError, 'Not configured yet' unless MetalArchives.config

        @faraday ||= Faraday.new do |f|
          f.request   :url_encoded            # form-encode POST params
          f.adapter   Faraday.default_adapter
          f.response  :logger if !!MetalArchives.config.debug      # log requests to STDOUT
          f.use       MetalArchives::Middleware
        end
      end

      ##
      # Map models to parser classes
      #
      def resolve_parser(model)
        Parsers.const_get model.to_s.capitalize
      end
  end
end
