# frozen_string_literal: true

RSpec.describe MetalArchives::Types::Model do
  subject(:type_class) { described_class.Type(MetalArchives::Band) }

  let(:band) { MetalArchives::Band.new(id: 1) }

  it "casts to model" do
    expect(type_class.cast(1)).to eq band
  end

  it "serializes to string" do
    expect(type_class.serialize(band)).to eq 1
  end

  it "is registered" do
    expect { MetalArchives::Types.lookup(:artist) }.not_to raise_error
    expect { MetalArchives::Types.lookup(:band) }.not_to raise_error
    expect { MetalArchives::Types.lookup(:release) }.not_to raise_error
  end
end
