# frozen_string_literal: true

module MetalArchives
  CACHE_STRATEGIES = %w(memory redis).freeze

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
    # Cache strategy
    #
    attr_accessor :cache_strategy

    ##
    # Cache strategy options
    #
    attr_accessor :cache_options

    ##
    # Default configuration values
    #
    def initialize(**attributes)
      attributes.each { |key, value| send(:"#{key}=", value) }

      @endpoint ||= "https://www.metal-archives.com/"
      @logger ||= Logger.new $stdout

      @cache_strategy ||= "memory"
      @cache_options ||= { size: 100 }
    end

    ##
    # Validate configuration
    #
    # [Raises]
    # - rdoc-ref:MetalArchives::Errors::ConfigurationError when configuration is invalid
    #
    def validate!
      raise Errors::InvalidConfigurationError, "app_name has not been configured" if app_name.blank?
      raise Errors::InvalidConfigurationError, "app_version has not been configured" if app_version.blank?
      raise Errors::InvalidConfigurationError, "app_contact has not been configured" if app_contact.blank?
      raise Errors::InvalidConfigurationError, "cache_strategy has not been configured" if cache_strategy.blank?
      raise Errors::InvalidConfigurationError, "cache_strategy must be one of: #{CACHE_STRATEGIES.join(', ')}" if CACHE_STRATEGIES.exclude?(cache_strategy.to_s)
    end
  end
end
