require 'faraday'
require 'nokogiri'

module MetalArchives
  class Client
    def http
      @faraday ||= Faraday.new do |f|
        f.request   :url_encoded            # form-encode POST params
        f.adapter   Faraday.default_adapter
        f.use       MetalArchives::Middleware
      end
    end

    def find_resource(model, query)
      raise 'MetalArchives has not been configured' unless MetalArchives.config

      parser = Parser.constantize(model)

      url = parser.find_endpoint(query)
      response = http.get(url)
      object = constantize(model).new parser.parse(response)

      object
    end
  end
end
