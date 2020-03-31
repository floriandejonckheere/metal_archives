# frozen_string_literal: true

require "faraday"

module MetalArchives
  module Middleware
    ##
    # Force UTF-8 conversion
    #
    class Encoding < Faraday::Response::Middleware # :nodoc:
      def on_complete(env)
        env.response.body.force_encoding("utf-8")
      end
    end
  end
end
