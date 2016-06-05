$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'test/unit'

require 'metal_archives'
# Configuration
MetalArchives.configure do |c|
  c.app_name = 'MetalArchivesGemTestSuite'
  c.app_version = MetalArchives::VERSION
  c.app_contact = `git config user.email`.chomp || 'user@example.com'

  c.cache_path = File.join(File.dirname(__FILE__), '..', 'tmp', 'spec_cache')
  c.perform_caching = true
  c.debug = true
end

def data_for(filename)
  File.read(File.join(File.dirname(__FILE__) + "/data/#{filename}"))
end
