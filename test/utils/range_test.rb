$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'test/unit'

require 'metal_archives/utils/range'

class RangeTest < Test::Unit::TestCase
  def test_basic_attributes
    range = MetalArchives::Range.new 3, 5

    assert_respond_to range, :begin
    assert_respond_to range, :end

    assert_equal 3, range.begin
    assert_equal 5, range.end

    assert range.begin?
    assert range.end?
  end

  def test_nil
    range = MetalArchives::Range.new nil, 5

    assert !range.begin?
    assert range.end?

    assert_equal nil, range.begin
    assert_equal 5, range.end
  end

  def test_comparable
    range1 = MetalArchives::Range.new(1, 3)
    range2 = MetalArchives::Range.new(1, 3)
    range3 = MetalArchives::Range.new(nil, 3)
    range4 = MetalArchives::Range.new(nil, 3)
    range5 = MetalArchives::Range.new(1, nil)
    range6 = MetalArchives::Range.new(1, nil)

    assert_equal range1, range2
    assert_equal range3, range4
    assert_equal range5, range6
  end
end
