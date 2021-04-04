# frozen_string_literal: true

RSpec.describe MetalArchives::Attributable do
  subject(:model) { model_class.new }

  let(:model_class) do
    Class.new do
      include MetalArchives::Attributable

      attribute :my_string
      attribute :my_strings, multiple: true
      attribute :my_integer, type: :integer

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

  it "casts typed attributes" do
    model.my_integer = "3"

    expect(model.my_integer).to eq 3
  end

  it "casts multiple attributes" do
    model.my_strings = "My String"

    expect(model.my_strings).to eq ["My String"]
  end
end
