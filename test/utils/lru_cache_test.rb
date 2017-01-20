$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'test/unit'

require 'metal_archives/utils/lru_cache'

class LruCacheTest < Test::Unit::TestCase
  def test_lru
    cache = MetalArchives::LRUCache.new 3

    cache[:a] = 'one'
    cache[:b] = 'two'
    cache[:c] = 'three'

    assert_equal 3, cache.size

    cache[:d] = 'four'

    assert_equal 3, cache.size

    assert_equal 'two', cache[:b]
    assert_equal 'three', cache[:c]
    assert_equal 'four', cache[:d]
    assert_equal nil, cache[:a]
  end
end
