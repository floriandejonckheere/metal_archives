require_relative '../test_helper'

##
# Tests on live API
#
# If a test fails, please check the online results to make sure it's not
# the content itself that has changed.
#
class ArtistLiveTest < Test::Unit::TestCase
  def test_search_by_attributes
    omit 'not implemented yet'
  end

  def test_search_by_name
    omit 'not implemented yet'
  end

  def test_search_by_genre
    omit 'not implemented yet'
  end

  def test_find_by_attributes
    artist = MetalArchives::Artist.find_by(:name => 'Alquimia', :country => ISO3166::Country['ES'])

    assert_not_nil artist
    assert artist.is_a? MetalArchives::Artist
    assert_equal 3540361100, artist.id
  end

  def test_find_by_name_and_id
    artist = MetalArchives::Artist.find('Alquimia', 3540361100)

    assert_not_nil artist
    assert artist.is_a? MetalArchives::Artist
    assert_equal ISO3166::Country['ES'], artist.country
  end

  def test_find_by_name
    artist = MetalArchives::Artist.find('Alquimia')

    assert [
              ISO3166::Country['AR'],
              ISO3166::Country['ES'],
              ISO3166::Country['CL']
            ].include? artist.country
  end
end
