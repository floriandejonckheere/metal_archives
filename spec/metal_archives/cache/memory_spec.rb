# frozen_string_literal: true

RSpec.describe MetalArchives::Cache::Memory do
  let(:cache) { described_class.new size: 3 }

  describe "#[], #[]=" do
    it "stores and retrieves an object" do
      cache[:key] = "MyString"

      expect(cache[:key]).to eq "MyString"
    end
  end

  describe "#clear" do
    it "clears the cache" do
      cache[:key] = "MyString"
      cache.clear

      expect(cache[:key]).to be_nil
    end
  end

  describe "#include?" do
    it "peeks" do
      expect(cache).not_to include :key

      cache[:key] = "MyString"

      expect(cache).to include :key
    end
  end

  describe "#delete" do
    it "deletes a cache entry" do
      cache[:key] = "MyString"

      expect(cache).to include :key

      cache.delete :key

      expect(cache).not_to include :key
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
