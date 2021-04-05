# frozen_string_literal: true

RSpec.describe MetalArchives::Types::Text do
  it "casts to string" do
    expect(described_class.cast(1)).to eq "1"
  end

  it "serializes to string" do
    expect(described_class.serialize("1")).to eq "1"
  end

  it "is registered" do
    expect(MetalArchives::Types.lookup(:text)).to eq described_class
  end
end
