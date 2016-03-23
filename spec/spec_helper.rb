require 'metal_archives'

MetalArchives.configure do |c|
  test_email = `git config user.email`.chomp || 'user@example.com'

  c.app_name = 'MetalArchivesGemTestSuite'
  c.app_version = MetalArchives::VERSION
  c.contact = test_email

  c.cache_path = File.join(File.dirname(__FILE__), '..', 'tmp', 'spec_cache')
  c.perform_caching = true
end
