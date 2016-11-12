$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'test/unit'

require 'metal_archives/utils/collection'

class CollectionTest < Test::Unit::TestCase
  def test_each
    l = lambda do
      @i ||= 0

      return [] if @i >= 100
      items = (@i .. (@i + 9)).to_a
      @i += 10

      items
    end

    c = MetalArchives::Collection.new l

    i = 0
    c.each do |item|
      assert_equal i, item
      i += 1
    end

    assert_equal 100, i
  end

  def test_return
    l = lambda do
      @i ||= 0

      raise StandardError if @i >= 100
      items = (@i .. (@i + 9)).to_a
      @i += 10

      items
    end

    c = MetalArchives::Collection.new l

    i = 0
    c.each do |item|
      break if i == 99
      assert_equal i, item
      i += 1
    end

    assert_equal 99, i
  end
end
