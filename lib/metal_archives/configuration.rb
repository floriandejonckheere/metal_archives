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
    # Minimum time between queries
    #
    attr_accessor :query_interval

    ##
    # Maximum number of tries
    #
    attr_accessor :tries_limit

    ##
    # Print debug information
    #
    attr_accessor :debug
  end
end
