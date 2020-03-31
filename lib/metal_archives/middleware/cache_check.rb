# frozen_string_literal: true

require "faraday"

module MetalArchives
  module Middleware
    ##
    # Log cache status
    #
    class CacheCheck < Faraday::Response::Middleware # :nodoc:
      def on_complete(env)
        return unless MetalArchives.config.endpoint

        if env[:response_headers].key? "x-cache-status"
          MetalArchives.config.logger.info "Cache #{env[:response_headers]['x-cache-status'].downcase} for #{env.url}"
        end
      end
    end
  end
end
