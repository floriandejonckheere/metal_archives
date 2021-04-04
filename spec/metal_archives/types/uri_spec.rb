# frozen_string_literal: true

RSpec.describe MetalArchives::Types::URI do
  it "does not cast URIs" do
    expect(described_class.cast(URI("https://www.metal-archives.com"))).to eq URI("https://www.metal-archives.com")
  end

  it "casts to URI" do
    expect(described_class.cast("https://www.metal-archives.com")).to eq URI("https://www.metal-archives.com")
  end

  it "serializes to string" do
    expect(described_class.serialize(URI("https://www.metal-archives.com"))).to eq "https://www.metal-archives.com"
  end

  it "is registered" do
    expect(MetalArchives::Types.lookup(:uri)).to eq described_class
  end
end
