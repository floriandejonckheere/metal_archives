require_relative '../test_helper'

##
# Tests on live API
#
# If a test fails, please check the online results to make sure it's not
# the content itself that has changed.
#
class ArtistLiveTest < Test::Unit::TestCase
  def test_search_by
    omit 'not implemented yet'
  end

  def test_search
    countries = MetalArchives::Artist.search('Alquimia').map { |a| a.country }.sort

    assert_equals 3, countries.size
    assert_equals [
              ISO3166::Country['AR'],
              ISO3166::Country['ES'],
              ISO3166::Country['CL']
            ], countries
  end

  def test_find_by
    #~ artist = MetalArchives::Artist.find_by(:name => 'Alquimia', :country => ISO3166::Country['ES'])

    #~ assert_not_nil artist
    #~ assert artist.is_a? MetalArchives::Artist
    #~ assert_equal 3540361100, artist.id
  end

  def test_find_by_id
    artist = MetalArchives::Artist.find(3540361100)

    assert_not_nil artist
    assert artist.is_a? MetalArchives::Artist
    assert_equal 'Alquimia', artist.name
    assert_equal ISO3166::Country['ES'], artist.country


    artist = MetalArchives::Artist.find(2)

    assert_nil artist
  end
end
