module MetalArchives
  class << self
    attr_accessor :config

    ##
    # Configure API options.
    #
    # A block must be specified, to which a
    # rdoc-ref:MetalArchives::Configuration parameter will be passed.
    #
    # Raises rdoc-ref:InvalidConfigurationException
    #
    def configure
      raise MetalArchives::Errors::InvalidConfigurationError, 'No configuration block given' unless block_given?
      yield MetalArchives.config ||= MetalArchives::Configuration.new

      raise MetalArchives::Errors::InvalidConfigurationError, 'app_name has not been configured' unless MetalArchives.config.app_name and not MetalArchives.config.app_name.empty?
      raise MetalArchives::Errors::InvalidConfigurationError, 'app_version has not been configured' unless MetalArchives.config.app_version and not MetalArchives.config.app_version.empty?
      raise MetalArchives::Errors::InvalidConfigurationError, 'app_contact has not been configured' unless MetalArchives.config.app_contact and not MetalArchives.config.app_contact.empty?

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
    # Whether to enable the cache
    #
    attr_accessor :enable_cache

    ##
    # ActiveSupport::Cache compatible store
    #
    attr_accessor :cache_store

    ##
    # Request throttling rate (in seconds per request per path)
    #
    attr_accessor :request_rate

    ##
    # Request timeout (in seconds per request per path)
    #
    attr_accessor :request_timeout

    ##
    # Print debug information
    #
    attr_accessor :debug

    ##
    # Default configuration values
    #
    def initialize
      @throttle_rate = 1
      @throttle_wait = 3
    end
  end
end
