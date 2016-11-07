$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'test/unit'

require 'metal_archives'
require 'metal_archives/error'

##
# Configuration tests
#
class ConfigurationTest < Test::Unit::TestCase
  def setup
    MetalArchives.config = nil
  end

  def test_no_configuration
    assert_raise MetalArchives::Errors::InvalidConfigurationError do
      MetalArchives::Band.search 'some_name'
    end
  end

  def test_missing_app_name
    assert_raise MetalArchives::Errors::InvalidConfigurationError do
      MetalArchives.configure do |c|
        c.app_version = MetalArchives::VERSION
        c.app_contact = `git config user.email`.chomp || 'user@example.com'
      end
    end
  end

  def test_missing_app_version
    assert_raise MetalArchives::Errors::InvalidConfigurationError do
      MetalArchives.configure do |c|
        c.app_name = 'MetalArchivesGemTestSuite'
        c.app_contact = `git config user.email`.chomp || 'user@example.com'
      end
    end
  end

  def test_missing_app_contact
    assert_raise MetalArchives::Errors::InvalidConfigurationError do
      MetalArchives.configure do |c|
        c.app_name = 'MetalArchivesGemTestSuite'
        c.app_version = MetalArchives::VERSION
      end
    end
  end

  def test_full_configuration
    assert_nothing_raised do
      MetalArchives.configure do |c|
        c.app_name = 'MetalArchivesGemTestSuite'
        c.app_version = MetalArchives::VERSION
        c.app_contact = `git config user.email`.chomp || 'user@example.com'
      end
    end
  end
end
