require 'faraday'
require 'faraday-http-cache'
require 'faraday_throttler'

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
      rescue Faraday::Error::ClientError => e
        raise Errors::APIError, e
      end

      private
        ##
        # Retrieve a HTTP client
        #
        #
        def client
          raise Errors::InvalidConfigurationError, 'Not configured yet' unless MetalArchives.config

          @faraday ||= Faraday.new do |f|
            f.request   :url_encoded            # form-encode POST params
            f.response  :logger, MetalArchives.config.logger

            f.use       MetalArchives::Middleware
            f.use       Faraday::HttpCache,
                                        :store => MetalArchives.config.cache_store if !!MetalArchives.config.enable_cache
            f.use       :throttler,
                                :rate => MetalArchives.config.request_rate,
                                :wait => MetalArchives.config.request_timeout,
                                :logger => MetalArchives.config.logger

            f.adapter   Faraday.default_adapter
          end
        end
    end
  end

  ##
  # Faraday middleware
  #
  class Middleware < Faraday::Middleware # :nodoc:
    def call(env)
      env[:request_headers].merge!(
        'User-Agent'  => user_agent_string,
        'Via'         => via_string,
        'Accept'      => accept_string
      )
      @app.call(env)
    end

    private
      def user_agent_string
        "#{MetalArchives.config.app_name}/#{MetalArchives.config.app_version} ( #{MetalArchives.config.app_contact} )"
      end

      def accept_string
        'application/json'
      end

      def via_string
        "gem metal_archives/#{VERSION}"
      end
  end
end
