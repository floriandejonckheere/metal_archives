# frozen_string_literal: true

require "openssl"

require "zeitwerk"
loader = Zeitwerk::Loader.for_gem
load.enable_reloading if ENV["METAL_ARCHIVES_ENV"] == "development"
loader.inflector.inflect(
  "http_client" => "HTTPClient",
  "lru_cache" => "LRUCache"
)
loader.collapse("lib/metal_archives/models")
loader.setup

##
# Metal Archives Ruby API
#
module MetalArchives
  class << self
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

      unless MetalArchives.config.app_name && !MetalArchives.config.app_name.empty?
        raise MetalArchives::Errors::InvalidConfigurationError, "app_name has not been configured"
      end
      unless MetalArchives.config.app_version && !MetalArchives.config.app_version.empty?
        raise MetalArchives::Errors::InvalidConfigurationError, "app_version has not been configured"
      end
      unless MetalArchives.config.app_contact && !MetalArchives.config.app_contact.empty?
        raise MetalArchives::Errors::InvalidConfigurationError, "app_contact has not been configured"
      end
    end
  end
end
