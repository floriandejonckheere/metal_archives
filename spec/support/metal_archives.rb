# frozen_string_literal: true

require "metal_archives"

MetalArchives.configure do |c|
  ## Application identity (required)
  c.app_name = "MetalArchivesGemTestSuite"
  c.app_version = MetalArchives::VERSION
  c.app_contact = "user@example.com"

  ## Enable Redis as caching backend (optional, overrides default memory cache)
  # c.cache_strategy = :redis
  # c.cache_options = { url: "redis://redis:6379", ttl: 1.month.to_i }

  ## Metal Archives endpoint (optional, overrides default)
  c.endpoint = ENV["MA_ENDPOINT"] if ENV["MA_ENDPOINT"]
  c.endpoint_user = ENV["MA_ENDPOINT_USER"] if ENV["MA_ENDPOINT_USER"]
  c.endpoint_password = ENV["MA_ENDPOINT_PASSWORD"] if ENV["MA_ENDPOINT_PASSWORD"]

  ## Custom logger (optional)
  c.logger = Logger.new $stdout
  c.logger.level = Logger::INFO
end
