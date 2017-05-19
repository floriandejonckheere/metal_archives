# frozen_string_literal: true

require 'metal_archives'

MetalArchives.configure do |c|
  ## Application identity (required)
  c.app_name = 'MetalArchivesGemTestSuite'
  c.app_version = MetalArchives::VERSION
  c.app_contact = `git config user.email`.chomp

  ## Custom cache size per object class (optional, overrides defaults)
  # c.cache_size = 100

  ## Metal Archives endpoint (optional, overrides default)
  c.endpoint = ENV['MA_ENDPOINT'] if ENV['MA_ENDPOINT']

  ## Custom logger (optional)
  # c.logger = Logger.new File.new('metal_archives.log')
end
