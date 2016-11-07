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
      raise ArgumentError, 'No configuration block given' unless block_given?
      yield MetalArchives.config ||= MetalArchives::Configuration.new
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
