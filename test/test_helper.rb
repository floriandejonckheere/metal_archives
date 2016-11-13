$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'test/unit'

require 'metal_archives'

# Configuration
puts "Debug log is written to /tmp/test-#{Process.pid}.log"
logger = Logger.new File.open('/tmp/test-#{Process.pid}.log', 'a')
logger.level = Logger::DEBUG

MetalArchives.configure do |c|
  c.app_name = 'MetalArchivesGemTestSuite'
  c.app_version = MetalArchives::VERSION
  c.app_contact = `git config user.email`.chomp || 'user@example.com'

  # Cache config (optional)
  c.enable_cache = false
  # c.cache_store = ActiveSupport::Cache.lookup_store(:file_store, '/tmp/metal_archives-cache')

  # Request throttling (optional, overrides defaults)
  c.request_rate = 1
  c.request_timeout = 3

  # Custom logger (optional)
  c.logger = logger
end
