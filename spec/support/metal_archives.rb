# frozen_string_literal: true

require "metal_archives"

MetalArchives.configure do |c|
  ## Application identity (required)
  c.app_name = "MetalArchivesGemTestSuite"
  c.app_version = MetalArchives::VERSION
  c.app_contact = "user@example.com"

  ## Custom cache size per object class (optional, overrides defaults)
  # c.cache_size = 100

  ## Metal Archives endpoint (optional, overrides default)
  c.endpoint = ENV["MA_ENDPOINT"] if ENV["MA_ENDPOINT"]
  c.endpoint_user = ENV["MA_ENDPOINT_USER"] if ENV["MA_ENDPOINT_USER"]
  c.endpoint_password = ENV["MA_ENDPOINT_PASSWORD"] if ENV["MA_ENDPOINT_PASSWORD"]

  puts "Using #{c.endpoint} as MA endpoint"

  ## Custom logger (optional)
  c.logger = Logger.new $stdout
  c.logger.level = Logger::INFO
end
