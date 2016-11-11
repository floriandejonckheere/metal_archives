require_relative '../test_helper'

require 'metal_archives/parsers/band'

##
# Property testing
#
# If a test fails, please check the online results to make sure it's not
# the content itself that has changed.
#
class ArtistPropertyTest < Test::Unit::TestCase
  def test_basic_attributes
    artist = MetalArchives::Artist.find 60908

    assert artist.is_a? MetalArchives::Artist
    assert_equal 60908, artist.id
    assert_equal 'Alberto Rionda', artist.name
    assert_empty artist.aliases
    assert_equal ISO3166::Country['ES'], artist.country
    assert_equal 'Oviedo, Asturias', artist.location
    assert_equal Date.new(1972, 9, 2), artist.date_of_birth
    assert_equal :male, artist.gender
    assert_match 'Avalanch', artist.biography
    assert_match 'Sanctuarium Estudios', artist.trivia
  end

  def test_map_params
    assert_equal 'name', MetalArchives::Parsers::Artist.map_params(:name => 'name')[:query]
  end
end
