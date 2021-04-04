# frozen_string_literal: true

RSpec.describe MetalArchives::Types::Integer do
  it "casts to integer" do
    expect(described_class.cast("1")).to eq 1
  end

  it "serializes to string" do
    expect(described_class.serialize(1)).to eq "1"
  end

  it "is registered" do
    expect(MetalArchives::Types.lookup(:integer)).to eq described_class
  end
end
