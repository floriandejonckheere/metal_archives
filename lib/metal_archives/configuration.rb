# frozen_string_literal: true

require "logger"

module MetalArchives
  ##
  # Contains configuration options
  #
  class Configuration
    ##
    # *Required.* Application name (used in request header)
    #
    attr_accessor :app_name

    ##
    # *Required.* Application version (used in request header)
    #
    attr_accessor :app_version

    ##
    # *Required.* Application contact email (used in request header)
    #
    attr_accessor :app_contact

    ##
    # Override Metal Archives endpoint (defaults to http://www.metal-archives.com/)
    #
    attr_accessor :endpoint
    attr_reader :default_endpoint

    ##
    # Endpoint HTTP Basic authentication
    #
    attr_accessor :endpoint_user
    attr_accessor :endpoint_password

    ##
    # Additional Faraday middleware
    #
    attr_accessor :middleware

    ##
    # Request throttling rate (in seconds per request per path)
    #
    attr_accessor :request_rate

    ##
    # Request timeout (in seconds per request per path)
    #
    attr_accessor :request_timeout

    ##
    # Logger instance
    #
    attr_accessor :logger

    ##
    # Cache size (per object class)
    #
    attr_accessor :cache_size

    ##
    # Default configuration values
    #
    def initialize
      @default_endpoint = "https://www.metal-archives.com/"
      @throttle_rate = 1
      @throttle_wait = 3
      @logger = Logger.new STDOUT
      @cache_size = 100
    end
  end
end
