# frozen_string_literal: true

RSpec.describe MetalArchives::Cache::Redis do
  subject(:cache) { described_class.new }

  before do
    MetalArchives.configure do |c|
      c.cache_strategy = "redis"
      c.cache_options = { url: "redis://localhost:6379" }
    end

    MetalArchives.cache.clear
  end

  it_behaves_like "a cache strategy"
end
