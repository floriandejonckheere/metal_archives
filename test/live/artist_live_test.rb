require_relative '../test_helper'

##
# Tests on live API
#
# If a test fails, please check the online results to make sure it's not
# the content itself that has changed.
#
class ArtistLivetest < Test::Unit::TestCase
  def test_find_by_name
    # http://www.metal-archives.com/bands/Alquimia/3540361100
    artist = MetalArchives::Artist.find_by_name('Alquimia', 3540361100)

    assert_equal 'Alquimia', artist.name
    assert_equal 'Grado, Asturias', artist.location
    assert_equal :active, artist.status
    assert_equal Date.new(2013), artist.date_formed
    assert_equal ['Melodic Power'], artist.genres
    assert_equal ['Epic', 'Legends', 'Medieval'].sort, artist.themes.sort
  end
end
