# frozen_string_literal: true

RSpec.describe MetalArchives::Cache::Memory do
  subject(:cache) { described_class.new size: 3 }

  it_behaves_like "a cache strategy"

  describe "#validate!" do
    it "raises when size is not set" do
      expect { described_class.new size: nil }.to raise_error MetalArchives::Errors::InvalidConfigurationError
    end

    it "raises when size is not an integer" do
      expect { described_class.new size: 3.5 }.to raise_error MetalArchives::Errors::InvalidConfigurationError
    end
  end

  it "implements LRU caching" do
    cache[:a] = "one"
    cache[:b] = "two"
    cache[:c] = "three"
    cache[:d] = "four"

    expect(cache[:b]).to eq "two"
    expect(cache[:c]).to eq "three"
    expect(cache[:d]).to eq "four"
    expect(cache[:a]).to be_nil
  end
end
