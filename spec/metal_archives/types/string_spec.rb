# frozen_string_literal: true

RSpec.describe MetalArchives::Types::String do
  it "sanitizes string" do
    expect(described_class.cast("\"my string\"")).to eq "my string"
    expect(described_class.cast("  my string   ")).to eq "my string"
    expect(described_class.cast("\n\rmy string\0")).to eq "my string"
    expect(described_class.cast("my <strong>string</strong>")).to eq "my string"
  end

  it "casts to string" do
    expect(described_class.cast(1)).to eq "1"
  end

  it "serializes to string" do
    expect(described_class.serialize("1")).to eq "1"
  end

  it "is registered" do
    expect(MetalArchives::Types.lookup(:string)).to eq described_class
  end
end
