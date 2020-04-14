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

        MetalArchives.config.logger.info "Cache #{env[:response_headers]['x-cache-status'].downcase} for #{env.url}" if env[:response_headers].key? "x-cache-status"
      end
    end
  end
end
