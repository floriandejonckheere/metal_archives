# frozen_string_literal: true

RSpec.describe MetalArchives::Types::Boolean do
  it "casts to boolean" do
    expect(described_class.cast("true")).to eq true
    expect(described_class.cast("1")).to eq true
    expect(described_class.cast("on")).to eq true

    expect(described_class.cast("false")).to eq false
    expect(described_class.cast("0")).to eq false
    expect(described_class.cast("off")).to eq false
  end

  it "serializes to string" do
    expect(described_class.serialize(true)).to eq "true"
  end

  it "is registered" do
    expect(MetalArchives::Types.lookup(:boolean)).to eq described_class
  end
end
