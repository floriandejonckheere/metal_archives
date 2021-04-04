# frozen_string_literal: true

RSpec.describe MetalArchives::Attributable do
  subject(:model) { model_class.new }

  let(:model_class) do
    Class.new do
      include MetalArchives::Attributable

      attribute :my_string
      attribute :my_strings, multiple: true

      attribute :my_integer, type: :integer
      attribute :my_integers, type: :integer, multiple: true

      attribute :my_enum, enum: ["My Enum One", "My Enum Two"]
      attribute :my_enums, multiple: true, enum: ["My Enum One", "My Enum Two"]

      # Override load mechanism
      def loaded?
        true
      end
    end
  end

  it "defines a setter, getter and iffer" do
    model.my_string = "My String"

    expect(model.my_string).to eq "My String"
    expect(model).to be_my_string
  end

  describe "types" do
    it "casts value" do
      model.my_integer = "3"

      expect(model.my_integer).to eq 3
    end

    it "raises when value cannot be cast" do
      expect { model.my_integer = "My String" }.to raise_error ArgumentError
    end

    context "when attribute is multiple" do
      it "casts value" do
        model.my_strings = "My String"

        expect(model.my_strings).to eq ["My String"]
      end

      it "raises when value cannot be cast" do
        expect { model.my_integers = ["My String"] }.to raise_error ArgumentError
      end
    end
  end

  describe "enum" do
    it "sets value" do
      model.my_enum = "My Enum One"

      expect(model.my_enum).to eq "My Enum One"
    end

    it "raises when value is not allowed" do
      expect { model.my_enum = "My Enum Three" }.to raise_error ArgumentError
    end

    context "when attribute is multiple" do
      it "sets value" do
        model.my_enums = ["My Enum One", "My Enum Two"]

        expect(model.my_enums).to eq ["My Enum One", "My Enum Two"]
      end

      it "raises when value is not allowed" do
        expect { model.my_enums = ["My Enum One", "My Enum Three"] }.to raise_error ArgumentError
      end
    end
  end
end
