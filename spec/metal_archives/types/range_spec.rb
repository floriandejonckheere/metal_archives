# frozen_string_literal: true

RSpec.describe MetalArchives::Types::Range do
  it "does not cast ranges" do
    expect(described_class.cast(1..5)).to eq 1..5
  end

  it "raises when it's not a range" do
    expect { described_class.cast("1..5") }.to raise_error ArgumentError
  end

  it "serializes to string" do
    expect(described_class.serialize(1..5)).to eq "1..5"
  end

  it "is registered" do
    expect(MetalArchives::Types.lookup(:range)).to eq described_class
  end
end
