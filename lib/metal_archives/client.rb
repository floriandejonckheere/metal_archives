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
    # +model+ is an object deriving from rdoc-ref:BaseModel . +query+ is
    # a +Hash+ containing query parameters.
    #
    def find_resource(model, query)
      raise InvalidConfigurationException.new('No configuration present') unless MetalArchives.config

      parser = Parser.constantize(model)

      url = parser.find_endpoint(query)
      response = http.get(url)
      object = constantize(model).new parser.parse(response)

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
