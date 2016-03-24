require 'faraday'

module MetalArchives
  class Client
    def initialize
      @faraday ||= Faraday.new do |f|
        f.request   :url_encoded            # form-encode POST params
        f.adapter   Faraday.default_adapter
        f.use       MetalArchives::Middleware
      end
    end
  end
end
