require_relative '../test_helper'

require 'metal_archives/models/base_model'

class BaseModelTestClass < MetalArchives::BaseModel
  property :simple
  property :complex,            :type => Date
  property :multiple,                               :multiple => true
  property :multiple_complex,   :type => Date,      :multiple => true
  enum :enum,                   :values => [:value_one, :value_two]
  boolean :boolean
  boolean :multiple_boolean,                        :multiple => true
end

class BaseModelTest < Test::Unit::TestCase
  def setup
    @object = BaseModelTestClass.new
  end

  def test_simple_property
    assert !@object.simple?

    assert_nothing_raised do
      @object.simple = 'String'
    end

    assert @object.simple?

    assert_raise TypeError do
      @object.simple = 4
    end
  end

  def test_complex_property
    assert !@object.complex?

    assert_nothing_raised do
      @object.complex = Date.new(2016, 1, 1)
    end

    assert @object.complex?

    assert_raise TypeError do
      @object.complex = 'String'
    end
  end

  def test_multiple_property
    assert !@object.multiple?

    assert_nothing_raised do
      @object.multiple = ['a', 'b']
      @object.multiple << 'c'
    end

    assert @object.multiple?

    assert_raise TypeError do
      @object.multiple = 'String'
    end
    assert_raise TypeError do
      @object.multiple = [1, 3]
    end
  end

  def test_multiple_complex
    assert !@object.multiple_complex?

    assert_nothing_raised do
      @object.multiple_complex = [Date.new(2015), Date.new(2014)]
      @object.multiple_complex << Date.new(2016)
    end

    assert @object.multiple_complex?

    assert_raise TypeError do
      @object.multiple_complex = 'String'
    end
    assert_raise TypeError do
      @object.multiple_complex = [1, 3]
    end
  end

  def test_enum_type
    assert !@object.enum?

    assert_nothing_raised do
      @object.enum = :value_one
      @object.enum = :value_two
    end

    assert @object.enum?

    assert_raise TypeError do
      @object.enum = :value_three
    end

    assert_raise TypeError do
      @object.enum = 'String'
    end
  end

  def test_boolean_type
    assert !@object.boolean?

    assert_nothing_raised do
      @object.boolean = false
      @object.boolean = true
    end

    assert @object.boolean?
    @object.boolean = false
    assert @object.boolean?

    assert_raise TypeError do
      @object.boolean = 'String'
    end

    assert_raise TypeError do
      @object.boolean = :true
    end
  end

  def test_multiple_boolean
    assert !@object.multiple_boolean?

    assert_nothing_raised do
      @object.multiple_boolean = [true, true, false]
      @object.multiple_boolean << false
    end

    assert @object.multiple_boolean?

    assert_raise TypeError do
      @object.multiple_boolean = 'String'
    end
    assert_raise TypeError do
      @object.multiple_boolean = ['true', 'false']
    end
  end
end
