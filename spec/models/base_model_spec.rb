# frozen_string_literal: true

##
# Sample model without :id property or :assemble method
#
class ModelOne < MetalArchives::BaseModel
  property :property_one
end

##
# Sample model without :assemble method
#
class ModelTwo < MetalArchives::BaseModel
  property :id
  property :property_one
end

##
# Sample complete model
#
class ModelThree < MetalArchives::BaseModel
  property :id
  property :property_one

  def assemble
    { property_one: "Property One" }
  end
end

##
# Sample complete model
#
class ModelFour < MetalArchives::BaseModel
  property :id
  property :property_one

  def assemble
    { property_one: "Property One" }
  end
end

##
# Sample invalid model
#
class ModelFive < MetalArchives::BaseModel
  property :id
  property :property_one

  def assemble
    raise MetalArchives::Errors::APIError
  end
end

RSpec.describe MetalArchives::BaseModel do
  it "requires an :id property" do
    expect(-> { ModelOne.new(property_one: "foo") }).to raise_error MetalArchives::Errors::NotImplementedError
  end

  it "requires an :assemble method" do
    expect(-> { ModelTwo.new(id: "foo").property_one }).to raise_error MetalArchives::Errors::NotImplementedError
  end

  it "defines methods" do
    model = ModelTwo.new id: "foo"

    expect(model).to respond_to :id
    expect(model).to respond_to :id=
    expect(model).to respond_to :id?
    expect(model).to respond_to :property_one
    expect(model).to respond_to :property_one=
    expect(model).to respond_to :property_one?
    expect(model).not_to respond_to :property_two
    expect(model).not_to respond_to :property_two=
    expect(model).not_to respond_to :property_two?
  end

  it "returns properties" do
    model = ModelThree.new id: "foo", property_one: "bar"

    model.instance_eval { |_m| @loaded = true }
    expect(model.id).to eq "foo"
    expect(model.property_one).to eq "bar"
  end

  it "sets properties" do
    model = ModelThree.new id: "foo", property_one: "bar"

    model.instance_eval { |_m| @loaded = true }
    model.id = "baz"
    model.property_one = "bat"

    expect(model.id).to eq "baz"
    expect(model.property_one).to eq "bat"
  end

  it "checks properties" do
    model = ModelThree.new id: "foo", property_one: "bar"
    model2 = ModelThree.new id: "foo"
    model2.load!
    model2.property_one = nil

    expect(model.id?).to be true
    expect(model.property_one?).to be true

    expect(model2.id?).to be true
    expect(model2.property_one?).to be false
  end

  it "calls assemble" do
    model = ModelThree.new id: "foo"

    expect(model.id).to eq "foo"
    expect(model.property_one).to eq "Property One"
  end

  it "lazily loads" do
    model = ModelThree.new id: "foo"

    expect(model).to be_instance_variable_defined "@id"
    expect(model).not_to be_instance_variable_defined "@property_one"

    model.property_one

    expect(model).to be_instance_variable_defined "@id"
    expect(model).to be_instance_variable_defined "@property_one"
    expect(model.property_one).to eq "Property One"
  end

  it "implements the load! operation" do
    model = ModelThree.new id: "foo"

    expect(model).to be_instance_variable_defined "@id"
    expect(model).not_to be_instance_variable_defined "@property_one"

    model.load!

    expect(model).to be_instance_variable_defined "@id"
    expect(model).to be_instance_variable_defined "@property_one"
    expect(model.property_one).to eq "Property One"
  end

  it "implements the equal operator" do
    m1 = ModelThree.new id: "id_one"
    m2 = ModelThree.new id: "id_one"
    m3 = ModelThree.new id: "id_two"
    m4 = ModelFour.new id: "id_one"

    expect(m1).to eq m2
    expect(m2).not_to eq m3
    expect(m1).not_to eq m3
    expect(m1).not_to eq m4
    expect(m2).not_to eq m4
  end

  describe "loaded?" do
    it "has a :loaded? method" do
      expect(ModelThree.new).to respond_to :loaded?
    end

    it "returns false on lazy load" do
      m = ModelThree.new id: "id_one"

      expect(m).not_to be_loaded
    end

    it "returns true on load!" do
      m = ModelThree.new id: "id_one"
      m.load!

      expect(m).to be_loaded
    end
  end

  describe "cached?" do
    context "valid model" do
      it "has a :cached? method" do
        expect(ModelThree.new).to respond_to :cached?
      end

      it "doesn't cache lazily loaded objects" do
        m = ModelThree.new id: "id_one"

        expect(m).not_to be_loaded
        expect(m).not_to be_cached
      end

      it "caches loaded objects" do
        m = ModelThree.new id: "id_one"
        m.load!

        expect(m).to be_loaded
        expect(m).to be_cached
      end
    end

    context "invalid model" do
      it "has a :cached? method" do
        expect(ModelFive.new).to respond_to :cached?
      end

      it "doesn't cache lazily loaded objects" do
        m = ModelFive.new id: "id_one"

        expect(m).not_to be_loaded
        expect(m).not_to be_cached
      end

      it "doesn't cache loaded invalid objects" do
        m = ModelFive.new id: "id_one"
        expect(-> { m.load! }).to raise_error MetalArchives::Errors::APIError

        expect(m).not_to be_loaded
        expect(m).not_to be_cached
      end
    end
  end
end
