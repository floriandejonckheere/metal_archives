# frozen_string_literal: true

require 'faraday'

module MetalArchives
  module Middleware
    ##
    # Dynamically rewrite endpoints
    #
    class RewriteEndpoint < Faraday::Middleware
      def call(env)
        RewriteEndpoint.rewrite(env[:url])

        @app.call env
      end

      class << self
        def rewrite(uri)
          return uri unless MetalArchives.config.endpoint

          new_uri = uri.clone

          default_uri = URI MetalArchives.config.default_endpoint
          rewritten_uri = URI MetalArchives.config.endpoint

          if uri.host == default_uri.host && uri.scheme == default_uri.scheme
            new_uri.host = rewritten_uri.host
            new_uri.scheme = rewritten_uri.scheme

            MetalArchives.config.logger.debug "Rewrite #{uri.to_s} to #{new_uri}"
          end

          new_uri
        end
      end
    end
  end
end
