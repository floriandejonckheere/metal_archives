# frozen_string_literal: true

RSpec.describe MetalArchives::Types::Country do
  it "does not cast countries" do
    expect(described_class.cast(ISO3166::Country["BE"])).to eq ISO3166::Country["BE"]
  end

  it "casts to date" do
    expect(described_class.cast("BE")).to eq ISO3166::Country["BE"]
  end

  it "serializes to string" do
    expect(described_class.serialize(ISO3166::Country["BE"])).to eq "BE"
  end

  it "is registered" do
    expect(MetalArchives::Types.lookup(:country)).to eq described_class
  end
end
