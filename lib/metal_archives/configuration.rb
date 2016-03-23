module MetalArchives
  class << self
    def configure
      raise 'Configuration block missing' unless block_given?
      yield @config ||= MetalArchives::Configuration.new
    end
  end

  class Configuration
    attr_accessor :app_name, :app_version, :app_contact,
                  :cache_path, :perform_caching,
                  :query_interval, :tries_limit
  end
end
