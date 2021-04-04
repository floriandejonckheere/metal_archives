# frozen_string_literal: true

RSpec.describe MetalArchives::Types::Float do
  it "casts to float" do
    expect(described_class.cast("1.3")).to eq 1.3
  end

  it "serializes to string" do
    expect(described_class.serialize(1.3)).to eq "1.3"
  end

  it "is registered" do
    expect(MetalArchives::Types.lookup(:float)).to eq described_class
  end
end
