$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'test/unit'

require 'metal_archives/utils/collection'

$proc = lambda do
  @i ||= 0

  return [] if @i >= 100

  items = (@i .. (@i + 9)).to_a

  @i += 10

  items
end

class CollectionTest < Test::Unit::TestCase
  def test_each
    c = MetalArchives::Collection.new $proc

    i = 0
    c.each do |item|
      assert_equal i, item
      i += 1
    end
  end
end
