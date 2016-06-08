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

  def test_map_status
    assert_equal '', MetalArchives::Parsers::Band.send(:map_status, nil)
    assert_equal 'Active', MetalArchives::Parsers::Band.send(:map_status, :active)
    assert_equal 'Split-up', MetalArchives::Parsers::Band.send(:map_status, :split_up)
    assert_equal 'On hold', MetalArchives::Parsers::Band.send(:map_status, :on_hold)
    assert_equal 'Unknown', MetalArchives::Parsers::Band.send(:map_status, :unknown)
    assert_equal 'Changed name', MetalArchives::Parsers::Band.send(:map_status, :changed_name)
    assert_equal 'Disputed', MetalArchives::Parsers::Band.send(:map_status, :disputed)

    assert_raises MetalArchives::Errors::ParserError do
      MetalArchives::Parsers::Band.send(:map_status, :invalid_status)
    end
  end

  def test_map_params
    assert_equal 'name', MetalArchives::Parsers::Band.map_params(:name => 'name')[:bandName]

    assert_equal 1, MetalArchives::Parsers::Band.map_params(:exact => true)[:exactBandMatch]
    assert_equal 1, MetalArchives::Parsers::Band.map_params(:exact => 'somevalue')[:exactBandMatch]
    assert_equal 0, MetalArchives::Parsers::Band.map_params(:exact => false)[:exactBandMatch]
    assert_equal 0, MetalArchives::Parsers::Band.map_params(:exact => nil)[:exactBandMatch]

    assert_equal '', MetalArchives::Parsers::Band.map_params({})[:bandName]
    assert_equal 0, MetalArchives::Parsers::Band.map_params({})[:exactBandMatch]
    assert_equal 'genre', MetalArchives::Parsers::Band.map_params({ :genre => 'genre'})[:genre]
    assert_equal '', MetalArchives::Parsers::Band.map_params({})[:genre]

    range = Range.new Date.new(2016), Date.new(2017)
    assert_equal 2016, MetalArchives::Parsers::Band.map_params({ :year => range })[:yearCreationFrom]
    assert_equal 2017, MetalArchives::Parsers::Band.map_params({ :year => range })[:yearCreationTo]
    assert_equal '', MetalArchives::Parsers::Band.map_params({})[:yearCreationFrom]
    assert_equal '', MetalArchives::Parsers::Band.map_params({})[:yearCreationTo]

    assert_equal 'comment', MetalArchives::Parsers::Band.map_params({ :comment => 'comment' })[:bandNotes]
    # :status is tested in test_map_status
    assert_equal 'themes', MetalArchives::Parsers::Band.map_params({ :lyrical_themes => 'themes' })[:themes]
    assert_equal 'location', MetalArchives::Parsers::Band.map_params({ :location => 'location' })[:location]
    assert_equal 'label', MetalArchives::Parsers::Band.map_params({ :label => 'label' })[:bandLabelName]
    assert_equal 1, MetalArchives::Parsers::Band.map_params({ :independent => true })[:indieLabelBand]
    assert_equal 1, MetalArchives::Parsers::Band.map_params({ :independent => 'some value' })[:indieLabelBand]
    assert_equal 1, MetalArchives::Parsers::Band.map_params({ :independent => '' })[:indieLabelBand]
    assert_equal 0, MetalArchives::Parsers::Band.map_params({ :independent => false })[:indieLabelBand]
    assert_equal 0, MetalArchives::Parsers::Band.map_params({ :independent => nil })[:indieLabelBand]

    country = ISO3166::Country['BE']
    country2 = ISO3166::Country['NL']
    assert_equal ['BE'], MetalArchives::Parsers::Band.map_params({ :country => country })[:country]
    assert_equal ['BE', 'NL'], MetalArchives::Parsers::Band.map_params({ :country => [country, country2] })[:country]

    assert_equal ['BE'], MetalArchives::Parsers::Band.map_params({ :country => ['BE'] })[:country]
    assert_equal ['BE', 'NL'], MetalArchives::Parsers::Band.map_params({ :country => ['BE', 'NL'] })[:country]
  end
end
