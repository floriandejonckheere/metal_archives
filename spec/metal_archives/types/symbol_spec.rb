# frozen_string_literal: true

RSpec.describe MetalArchives::Types::Symbol do
  it "casts to string" do
    expect(described_class.cast("string")).to eq :string
  end

  it "serializes to string" do
    expect(described_class.serialize(:string)).to eq "string"
  end

  it "is registered" do
    expect(MetalArchives::Types.lookup(:symbol)).to eq described_class
  end
end
