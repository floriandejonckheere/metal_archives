module MetalArchives
module Clients
  ##
  # Band client
  #
  class Band < BaseClient # :nodoc:
    ##
    # Find a +model+ using ID
    #
    # Returns rdoc-ref:Band
    #
    # Raises rdoc-ref:MetalArchives::Errors::APIError on error
    #
    def find_by_id
      url = parser.find_endpoint @query[:id]

      response = http.get url
      raise MetalArchives::Errors::APIError, response.status if response.status >= 400

      model.new parser.parse_html(response.body).merge(:id => @query[:id])
    end

    ##
    # Find a +model+ using +query+
    #
    # Returns rdoc-ref:Band or nil
    #
    # Raises rdoc-ref:MetalArchives::Errors::APIError on error
    #
    def find
      url = parser.search_endpoint @query
      params = parser.map_params @query

      response = http.get url, params
      raise MetalArchives::Errors::APIError, response.status if response.status >= 400

      json = parser.parse_json response.body

      return nil if json['aaData'].empty?

      data = json['aaData'].first
      @query[:id] = Nokogiri::HTML(data.first).xpath('//a/@href').first.value.gsub('\\', '').split('/').last.gsub(/\D/, '').to_i

      find_by_id
    end

    ##
    # Find multiple +model+s using +query+
    #
    # Returns (possibly empty) +Array+ of rdoc-ref:Band
    #
    # Raises rdoc-ref:MetalArchives::Errors::APIError on error
    #
    def search
      url = parser.search_endpoint @query
      params = parser.map_params @query

      response = http.get url, params
      raise MetalArchives::Errors::APIError, response.status if response.status >= 400

      json = parser.parse_json response.body

      objects = []
      json['aaData'].each do |data|
        # Fetch Band for every ID in the results list
        objects << model.find(Nokogiri::HTML(data.first).xpath('//a/@href').first.value.gsub('\\', '').split('/').last.gsub(/\D/, '').to_i)
      end

      objects
    end
  end
end
end
