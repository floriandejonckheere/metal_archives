# frozen_string_literal: true

require "faraday"
require "faraday_throttler"

module MetalArchives
  ##
  # HTTP request client
  #
  class HTTPClient # :nodoc:
    class << self
      ##
      # Retrieve a HTTP resource
      #
      # [Raises]
      # - rdoc-ref:MetalArchives::Errors::InvalidIDError when receiving a status code == 404n
      # - rdoc-ref:MetalArchives::Errors::APIError when receiving a status code >= 400 (except 404)
      #
      def get(*params)
        response = client.get(*params)

        raise Errors::InvalidIDError, response.status if response.status == 404
        raise Errors::APIError, response.status if response.status >= 400

        response
      rescue Faraday::ClientError => e
        MetalArchives.config.logger.error e.response
        raise Errors::APIError, e
      end

      private

      ##
      # Retrieve a HTTP client
      #
      #
      def client
        raise Errors::InvalidConfigurationError, "Not configured yet" unless MetalArchives.config

        @faraday ||= Faraday.new do |f|
          f.request   :url_encoded # form-encode POST params
          f.response  :logger, MetalArchives.config.logger

          f.use       MetalArchives::Middleware::Headers
          f.use       MetalArchives::Middleware::CacheCheck
          f.use       MetalArchives::Middleware::RewriteEndpoint
          f.use       MetalArchives::Middleware::Encoding

          MetalArchives.config.middleware&.each { |m| f.use m }

          f.use       :throttler,
                      rate: MetalArchives.config.request_rate,
                      wait: MetalArchives.config.request_timeout,
                      logger: MetalArchives.config.logger

          f.adapter   Faraday.default_adapter
        end
      end
    end
  end
end
