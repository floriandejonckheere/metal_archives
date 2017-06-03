# frozen_string_literal: true

require 'faraday'

module MetalArchives
  module Middleware
    ##
    # Add appropriate request headers
    #
    class Headers < Faraday::Middleware # :nodoc:
      def call(env)
        headers = {
          'User-Agent' => user_agent_string,
          'Via' => via_string,
          'Accept' => accept_string
        }

        env[:request_headers].merge! headers

        @app.call env
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
end
