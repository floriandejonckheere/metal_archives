require 'faraday'
require 'nokogiri'

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
    def find_by(model, query)
      parser = resolve_parser model

      url = parser.search_endpoint query
      params = parser.map_params query

      response = http.get url, params
      return nil if response.status > 400
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
    def search_by(model, query)
      parser = resolve_parser model

      url = parser.search_endpoint query
      params = parser.map_params query

      response = http.get url, params
      return nil if response.status > 400
      object = MetalArchives.const_get(model.to_s.capitalize).new parser.parse_json response.body

      object
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
      def http
        raise InvalidConfigurationError, 'Not configured yet' unless MetalArchives.config

        @faraday ||= Faraday.new do |f|
          f.request   :url_encoded            # form-encode POST params
          f.adapter   Faraday.default_adapter
          f.use       MetalArchives::Middleware
        end
      end

      def resolve_parser(model)
        Parsers.const_get model.to_s.capitalize
      end
  end
end
