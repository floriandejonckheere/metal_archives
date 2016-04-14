require_relative '../test_helper'

require 'metal_archives/parsers/band'

class BandParserTest < Test::Unit::TestCase
  def test_basic_attributes
    band = MetalArchives::Parsers::Band.parse_html(data_for('pathfinder.html'))

    assert_equal 'Pathfinder', band[:name]
    assert_equal [], band[:aliases]
    assert_equal ISO3166::Country['PL'], band[:country]
    assert_equal 'Poznań', band[:location]
    assert_equal Date.new(2006), band[:date_formed]
    assert_equal [MetalArchives::Range.new(Date.new(2006), nil)], band[:date_active]
    assert_equal :active, band[:status]
    assert_equal ['Symphonic Power'], band[:genres]
    assert_equal ['Fantasy', 'Battles', 'Glory', 'The Four Elements', 'Metal'].sort, band[:lyrical_themes].sort
    assert_equal 'Pathfinder was founded by Arkadiusz Ruth and Karol Mania.', band[:comment]
    assert !band[:independent]
  end

  def test_multiple
    band = MetalArchives::Parsers::Band.parse_html(data_for('rhapsody_of_fire.html'))

    assert_equal ['Thundercross', 'Rhapsody'].sort, band[:aliases].sort
  end

  def test_associations
    omit 'not implemented yet'
    band = MetalArchives::Parsers::Band.parse_html(data_for('pathfinder.html'))
    # label
  end
end
