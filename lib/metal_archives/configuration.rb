# frozen_string_literal: true

module MetalArchives
  class << self
    ##
    # API configuration
    #
    # Instance of rdoc-ref:MetalArchives::Configuration
    #
    def config
      raise MetalArchives::Errors::InvalidConfigurationError, 'Gem has not been configured' unless @config

      @config
    end

    ##
    # Configure API options.
    #
    # A block must be specified, to which a
    # rdoc-ref:MetalArchives::Configuration parameter will be passed.
    #
    # [Raises]
    # - rdoc-ref:InvalidConfigurationException
    #
    def configure
      raise MetalArchives::Errors::InvalidConfigurationError, 'No configuration block given' unless block_given?
      @config = MetalArchives::Configuration.new
      yield @config

      @config.logger.level = @config.debug ? Logger::DEBUG : Logger::WARN

      raise MetalArchives::Errors::InvalidConfigurationError, 'app_name has not been configured' unless MetalArchives.config.app_name && !MetalArchives.config.app_name.empty?
      raise MetalArchives::Errors::InvalidConfigurationError, 'app_version has not been configured' unless MetalArchives.config.app_version && !MetalArchives.config.app_version.empty?
      raise MetalArchives::Errors::InvalidConfigurationError, 'app_contact has not been configured' unless MetalArchives.config.app_contact && !MetalArchives.config.app_contact.empty?
    end
  end

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
    # Verbose output
    #
    attr_accessor :debug

    ##
    # Cache size (per object class)
    #
    attr_accessor :cache_size

    ##
    # Default configuration values
    #
    def initialize
      @default_endpoint = 'https://www.metal-archives.com/'
      @throttle_rate = 1
      @throttle_wait = 3
      @logger = Logger.new STDOUT
      @debug = false
      @cache_size = 100
    end
  end
end
