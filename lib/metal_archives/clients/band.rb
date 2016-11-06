module MetalArchives
module Clients
  ##
  # Band client
  #
  class Band < BaseClient # :nodoc:
    ##
    # Find a +model+ using +query+
    #
    # Raises rdoc-ref:MetalArchives::Errors::APIError on error
    #
    def find
      if @query[:id]
        url = parser.find_endpoint @query[:id]

        response = http.get url
        raise MetalArchives::Errors::APIError, response.status if response.status >= 400

        return model.new parser.parse_html(response.body)
      else
        url = parser.search_endpoint @query
        params = parser.map_params @query

        response = http.get url, params
        raise MetalArchives::Errors::APIError, response.status if response.status >= 400

        return model.new parser.parse_json(response.body)
      end
    end

    ##
    # Find multiple +model+s using +query+
    #
    # Returns +Array+
    #
    # Raises rdoc-ref:MetalArchives::Errors::APIError on error
    #
    def search
      url = parser.search_endpoint @query
      params = parser.map_params @query

      response = http.get url, params
      raise MetalArchives::Errors::APIError, response.status if response.status >= 400

      # TODO: move this section to Parser#parse_json
      json = parser.parse_json response.body

      objects = []
      json['aaData'].each do |data|
        object = {
          :name => Nokogiri::HTML(data[0]).xpath("//text()").to_s.strip,
          :genres => MetalArchives::Parsers::ParserHelper.parse_genre(data[1]),
          :country => ISO3166::Country.find_country_by_name(data[2])
        }
        objects << model.new(object)
      end

      objects
    end
  end
end
end
