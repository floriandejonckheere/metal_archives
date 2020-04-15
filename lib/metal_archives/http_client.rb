# frozen_string_literal: true

require "http"

require "active_support/core_ext/hash/keys"
require "active_support/core_ext/module/delegation"

module MetalArchives
  class HTTPClient
    include Singleton

    class << self
      delegate_missing_to :instance
    end

    attr_reader :endpoint

    def initialize(endpoint = MetalArchives.config.endpoint)
      @endpoint = endpoint
    end

    def get(path, params = {})
      response = http
        .get(url_for(path), params: params)

      raise MetalArchives::Errors::InvalidIDError, response if response.code == 404
      raise MetalArchives::Errors::APIError, response unless response.status.success?

      response
    end

    private

    def http
      @http ||= HTTP
        .headers(headers)
        .use(logging: { logger: MetalArchives.config.logger })

      return @http unless MetalArchives.config.endpoint_user && MetalArchives.config.endpoint_password

      @http
        .basic_auth(user: MetalArchives.config.endpoint_user, pass: MetalArchives.config.endpoint_password)
    end

    def headers
      {
        user_agent: "#{MetalArchives.config.app_name}/#{MetalArchives.config.app_version} (#{MetalArchives.config.app_contact})",
        accept: "application/json",
      }
    end

    def url_for(path)
      "#{endpoint}#{path}"
    end
  end
end
