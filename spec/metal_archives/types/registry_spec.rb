# frozen_string_literal: true

RSpec.describe MetalArchives::Types::Registry do
  subject(:registry) { described_class.new }

  let(:my_type) do
    Class.new do
      def self.cast(value)
        value
      end

      def self.deserialize(value)
        value
      end
    end
  end

  describe "#register" do
    it "registers a type" do
      registry.register(:my_type, my_type)

      expect(registry.lookup(:my_type)).to eq my_type
    end
  end

  describe "#lookup" do
    it "looks up a type" do
      registry.register(:my_type, my_type)

      expect(registry.lookup(:my_type)).to eq my_type
    end

    it "raises when type was not registered" do
      expect { registry.lookup(:my_type) }.to raise_error KeyError
    end
  end
end
