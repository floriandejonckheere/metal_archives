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
    def find_resource(model, query)
      raise InvalidConfigurationError, 'Not configured yet' unless MetalArchives.config

      parser = Parsers.const_get model.to_s.capitalize

      url = parser.find_endpoint(query)
      response = http.get(url)
      object = MetalArchives.const_get(model.to_s.capitalize).new parser.parse response.body

      object
    end

    ##
    # Find multiple +model+s using +query+
    #
    # +model+ is an object deriving from rdoc-ref:BaseModel . +query+ is
    # a +Hash+ containing query parameters.
    #
    def search_resource(model, query)
      raise InvalidConfigurationError, 'Not configured yet' unless MetalArchives.config

      parser = Parsers.const_get model.to_s.capitalize

      url = parser.find_endpoint(query)
      response = http.get(url)
      object = MetalArchives.const_get(model.to_s.capitalize).new parser.parse response.body

      object
    end

    private
      def http
        @faraday ||= Faraday.new do |f|
          f.request   :url_encoded            # form-encode POST params
          f.adapter   Faraday.default_adapter
          f.use       MetalArchives::Middleware
        end
      end
  end
end
