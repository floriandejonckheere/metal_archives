require 'test_helper'

require 'metal_archives/models/base_model'

##
# Sample model without :id property
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
    instance_variable_set "@property_one", 'Property One'
  end
end

##
# Sample complete model
#
class ModelFour < MetalArchives::BaseModel
  property :id
  property :property_one

  def assemble
    instance_variable_set "@property_one", 'Property One'
  end
end

##
# BaseModel tests
#
class BaseModelTest < Test::Unit::TestCase
  def test_need_id
    assert_raise MetalArchives::Errors::NotImplementedError do
      ModelOne.new(:property_one => 'foo')
    end
  end

  def test_need_assemble
    assert_raise MetalArchives::Errors::NotImplementedError do
      ModelTwo.new(:id => 'foo').property_one
    end
  end

  def test_constructor
    model = ModelThree.new(:id => 'foo', :property_one => 'bar')

    assert model.instance_variable_defined? '@id'
    assert model.instance_variable_defined? '@property_one'
    assert !model.instance_variable_defined?('@property_two')
  end

  def test_methods
    model = ModelThree.new(:id => 'foo')

    assert_respond_to model, :id
    assert_respond_to model, :id?
    assert_respond_to model, :id=

    assert_respond_to model, :property_one
    assert_respond_to model, :property_one?
    assert_respond_to model, :property_one=
  end

  def test_assemble
    model = ModelThree.new :id => 'foo'

    assert_equal 'foo', model.id
    assert_equal 'Property One', model.property_one
  end

  def test_lazy_load
    model = ModelThree.new :id => 'foo'

    assert model.instance_variable_defined? '@id'
    assert !model.instance_variable_defined?('@property_one')

    model.property_one

    assert model.instance_variable_defined? '@id'
    assert model.instance_variable_defined? '@property_one'
    assert_equal 'Property One', model.property_one
  end

  def test_equality
    m1 = ModelThree.new :id => 'id_one'
    m2 = ModelThree.new :id => 'id_one'
    m3 = ModelThree.new :id => 'id_two'
    m4 = ModelFour.new :id => 'id_one'

    assert_equal m1, m2
    assert_not_equal m2, m3
    assert_not_equal m1, m3
    assert_not_equal m1, m4
  end
end
