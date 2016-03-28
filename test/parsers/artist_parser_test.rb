require_relative '../test_helper'

require 'metal_archives/parsers/artist'

class ArtistParserTest < Test::Unit::TestCase
  def test_basic_attributes
    artist = MetalArchives::Parsers::Artist.parse(data_for('pathfinder.html'))

    assert_equal 'Pathfinder', artist[:name]
    assert_equal [], artist[:aliases]
    assert_equal 'Poznań', artist[:location]
    assert_equal Date.new(2006), artist[:date_formed]
    assert_equal [MetalArchives::Range.new(Date.new(2006), nil)], artist[:date_active]
    assert_equal :active, artist[:status]
    assert_equal ['Symphonic Power'], artist[:genres]
    assert_equal ['Fantasy', 'Battles', 'Glory', 'The Four Elements', 'Metal'].sort, artist[:themes].sort
    assert_equal 'Pathfinder was founded by Arkadiusz Ruth and Karol Mania.', artist[:comment]
  end

  def test_multiple
    artist = MetalArchives::Parsers::Artist.parse(data_for('rhapsody_of_fire.html'))

    assert_equal ['Thundercross', 'Rhapsody'].sort, artist[:aliases].sort
  end

  def test_associations
    artist = MetalArchives::Parsers::Artist.parse(data_for('pathfinder.html'))
    # :date_active
    # country
    # label
  end
end
