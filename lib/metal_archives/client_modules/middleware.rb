require 'faraday'

module MetalArchives
  class Middleware < Faraday::Middleware
    def call(env)
      env[:request_headers].merge!(
        'User-Agent'  => user_agent_string,
        'Via'         => via_string,
        'Accept'      => accept_string
      )
      @app.call(env)
    end

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
