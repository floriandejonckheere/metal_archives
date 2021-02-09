# frozen_string_literal: true

require "zeitwerk"
require "byebug" if ENV["METAL_ARCHIVES_ENV"] == "development"
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
    # Cache instance
    #
    def cache
      raise MetalArchives::Errors::InvalidConfigurationError, "cache has not been configured" unless config.cache_strategy

      @cache ||= Cache.const_get(loader.inflector.camelize(config.cache_strategy, root))
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
      raise Errors::InvalidConfigurationError, "no configuration block given" unless block_given?

      @config = Configuration.new
      yield config

      config.validate!
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
      loader.do_not_eager_load(root.join("lib/metal_archives/cache"))
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
