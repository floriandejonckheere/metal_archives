# frozen_string_literal: true

require "zeitwerk"

require "active_support/all"

##
# Metal Archives Ruby API
#
module MetalArchives
  class << self
    # Code loader instance
    attr_reader :loader

    ##
    # Root path
    #
    def root
      @root ||= Pathname.new(File.expand_path(File.join("..", ".."), __FILE__))
    end

    ##
    # HTTP client
    #
    def http
      @http ||= HTTPClient.new
    end

    ##
    # API configuration
    #
    # Instance of rdoc-ref:MetalArchives::Configuration
    #
    def config
      raise MetalArchives::Errors::InvalidConfigurationError, "Gem has not been configured" unless @config

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
      raise MetalArchives::Errors::InvalidConfigurationError, "No configuration block given" unless block_given?

      @config = MetalArchives::Configuration.new
      yield @config

      raise MetalArchives::Errors::InvalidConfigurationError, "app_name has not been configured" unless MetalArchives.config.app_name && !MetalArchives.config.app_name.empty?
      raise MetalArchives::Errors::InvalidConfigurationError, "app_version has not been configured" unless MetalArchives.config.app_version && !MetalArchives.config.app_version.empty?

      return if MetalArchives.config.app_contact && !MetalArchives.config.app_contact.empty?

      raise MetalArchives::Errors::InvalidConfigurationError, "app_contact has not been configured"
    end

    ##
    # Set up application framework
    #
    def setup
      @loader = Zeitwerk::Loader.for_gem

      # Register inflections
      require root.join("config/inflections.rb")

      # Set up code loader
      loader.enable_reloading if ENV["METAL_ARCHIVES_ENV"] == "development"
      loader.collapse(root.join("lib/metal_archives/models"))
      loader.setup
      loader.eager_load

      # Load initializers
      Dir[root.join("config/initializers/*.rb")].sort.each { |f| require f }
    end
  end
end

def reload!
  MetalArchives.loader.reload
end

MetalArchives.setup
