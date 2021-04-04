# frozen_string_literal: true

RSpec.describe MetalArchives::Types::Date do
  it "does not cast dates" do
    expect(described_class.cast(Date.new(2000, 1, 1))).to eq Date.new(2000, 1, 1)
  end

  it "casts to date" do
    expect(described_class.cast("2000-01-01")).to eq Date.new(2000, 1, 1)
  end

  it "serializes to string" do
    expect(described_class.serialize(Date.new(2000, 1, 1))).to eq "2000-01-01"
  end

  it "is registered" do
    expect(MetalArchives::Types.lookup(:date)).to eq described_class
  end
end
