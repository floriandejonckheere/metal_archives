module MetalArchives
module Clients
  ##
  # Band client
  #
  class Band < BaseClient # :nodoc:
    ##
    # Find a +model+ using +query+
    #
    # [+query+]
    #     +Hash+ containing query parameters
    #
    # Raises rdoc-ref:MetalArchives::Errors::APIError on error
    #
    def find_by(query)
      url = parser.search_endpoint query
      params = parser.map_params query

      response = http.get url, params
      raise MetalArchives::Errors::APIError, response.status if response.status >= 400

      object = MetalArchives.const_get(model.to_s.capitalize).new parser.parse_json response.body

      object
    end

    ##
    # Find multiple +model+s using +query+
    #
    # [+query+]
    #     +Hash+ containing query parameters
    #
    # Returns +Array+
    #
    # Raises rdoc-ref:MetalArchives::Errors::APIError on error
    #
    def search_by(query)
      url = parser.search_endpoint query
      params = parser.map_params query

      response = http.get url, params
      raise MetalArchives::Errors::APIError, response.status if response.status >= 400

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
    # [+id+]
    #     +Integer+
    #
    def find_by_id(id)
      url = parser.find_endpoint :id => id

      response = http.get url
      return nil if response.status > 400
      object = MetalArchives.const_get(model.to_s.capitalize).new parser.parse_html response.body

      object
    end
  end
end
end
