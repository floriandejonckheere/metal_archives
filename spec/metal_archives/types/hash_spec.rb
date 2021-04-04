# frozen_string_literal: true

RSpec.describe MetalArchives::Types::Hash do
  it "casts to hash" do
    expect(described_class.cast([[:a, :b]])).to eq({ a: :b })
  end

  it "serializes to string" do
    expect(described_class.serialize({ a: :b })).to eq "{:a=>:b}"
  end

  it "is registered" do
    expect(MetalArchives::Types.lookup(:hash)).to eq described_class
  end
end
