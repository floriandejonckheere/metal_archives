# frozen_string_literal: true

RSpec.shared_examples "a cache strategy" do
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
end
