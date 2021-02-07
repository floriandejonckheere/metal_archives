# frozen_string_literal: true

RSpec.describe MetalArchives::LRUCache do
  let(:cache) { described_class.new 3 }

  it "stores and retrieves objects" do
    cache[:key] = "MyString"

    expect(cache[:key]).to eq "MyString"
  end

  it "clears cache" do
    cache[:key] = "MyString"
    cache.clear

    expect(cache[:key]).to be_nil
  end

  it "peeks" do
    expect(cache).not_to include :key

    cache[:key] = "MyString"

    expect(cache).to include :key
  end

  it "deletes" do
    cache[:key] = "MyString"

    expect(cache).to include :key

    cache.delete :key

    expect(cache).not_to include :key
  end

  it "implements LRU caching" do
    cache[:a] = "one"
    cache[:b] = "two"
    cache[:c] = "three"

    expect(cache.instance_variable_get("@size")).to eq 3

    cache[:d] = "four"

    expect(cache.instance_variable_get("@size")).to eq 3

    expect(cache[:b]).to eq "two"
    expect(cache[:c]).to eq "three"
    expect(cache[:d]).to eq "four"
    expect(cache[:a]).to be_nil
  end
end
