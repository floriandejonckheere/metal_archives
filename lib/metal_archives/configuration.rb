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
    # Override Metal Archives endpoint (defaults to https://www.metal-archives.com/)
    #
    attr_accessor :endpoint

    ##
    # Endpoint HTTP Basic authentication
    #
    attr_accessor :endpoint_user
    attr_accessor :endpoint_password

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
      @endpoint = "https://www.metal-archives.com/"
      @logger = Logger.new $stdout
      @cache_size = 100
    end
  end
end
