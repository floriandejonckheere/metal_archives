# frozen_string_literal: true

module MetalArchives
  ##
  # Generic HTTP client
  #
  class HTTPClient
    attr_reader :endpoint, :metrics

    def initialize(endpoint = MetalArchives.config.endpoint)
      @endpoint = endpoint
      @metrics = { hit: 0, miss: 0 }
    end

    def get(path, params = {})
      response = http
        .get(url_for(path), params: params)

      # Log cache status
      status = response.headers["x-cache-status"]&.downcase&.to_sym
      MetalArchives.config.logger.info "Cache #{status} for #{path}" if status

      case status
      when :hit
        metrics[:hit] += 1
      when :miss, :bypass, :expired, :stale, :updating, :revalidated
        metrics[:miss] += 1
      end
      raise Errors::NotFoundError, response if response.code == 404
      raise Errors::APIError, response unless response.status.success?

      response
    end

    private

    def http
      @http ||= HTTP
        .headers(headers)
        .use(logging: { logger: MetalArchives.config.logger })
        .encoding("utf-8")

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
