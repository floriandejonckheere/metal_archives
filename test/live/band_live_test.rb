require_relative '../test_helper'

##
# Tests on live API
#
# If a test fails, please check the online results to make sure it's not
# the content itself that has changed.
#
class BandLiveTest < Test::Unit::TestCase
  def test_find
    band = MetalArchives::Band.find 3540361100

    assert_not_nil band
    assert band.is_a? MetalArchives::Band
    assert_equal 'Alquimia', band.name
    assert_equal ISO3166::Country['ES'], band.country

    assert_match 'http', band.logo
    assert_match 'http', band.photo

    band = MetalArchives::Band.find(2)

    assert_nil band
  end

  def test_find_by
    band = MetalArchives::Band.find_by :name => 'Falconer'

    assert_not_nil band
    assert band.is_a? MetalArchives::Band
    assert_equal 'Falconer', band.name
    assert_equal 74, band.id
    assert_equal ISO3166::Country['SE'], band.country


    band = MetalArchives::Band.find_by :name => 'SomeNonExistantName'

    assert_nil band


    band = MetalArchives::Band.find_by(:name => 'Alquimia', :country => ISO3166::Country['ES'])

    assert_not_nil band
    assert band.is_a? MetalArchives::Band
    assert_equal 3540361100, band.id
  end

  def test_search_by
    assert_equal 5, MetalArchives::Band.search_by(:name => 'Alquimia').count

    assert_equal 3, MetalArchives::Band.search_by(:name => 'Lost Horizon').count
    assert_equal 2, MetalArchives::Band.search_by(:name => 'Lost Horizon', :exact => true).count

    assert_equal 2, MetalArchives::Band.search_by(:name => 'Alquimia', :genre => 'Melodic Power').count


      countries = MetalArchives::Band.search('Alquimia').map { |a| a.country }.sort

      assert_equal 5, countries.size
      assert countries.include? ISO3166::Country['AR']
      assert countries.include? ISO3166::Country['ES']
      assert countries.include? ISO3166::Country['CL']

    assert_equal 5, MetalArchives::Band.search_by(
              :name => 'Alquimia', :year => MetalArchives::Range.new(nil, nil)).count
    assert_equal 1, MetalArchives::Band.search_by(
              :name => 'Alquimia', :year => MetalArchives::Range.new(Date.new(2013), nil)).count
    assert_equal 1, MetalArchives::Band.search_by(
              :name => 'Alquimia', :year => MetalArchives::Range.new(Date.new(2008), Date.new(2008))).count
    assert_equal 2, MetalArchives::Band.search_by(
              :name => 'Alquimia', :year => MetalArchives::Range.new(Date.new(2008), Date.new(2013))).count
    assert_equal 5, MetalArchives::Band.search_by(
              :name => 'Alquimia', :year => MetalArchives::Range.new(nil, Date.new(2013))).count

    assert_equal 1, MetalArchives::Band.search_by(:name => 'Alquimia', :country => ISO3166::Country['ES']).count
    assert_equal 3, MetalArchives::Band.search_by(:name => 'Alquimia', :country => ISO3166::Country['AR']).count
    assert_equal 3, MetalArchives::Band.search_by(:name => 'Alquimia', :country => ISO3166::Country['AR']).count
    assert_equal 1, MetalArchives::Band.search_by(:name => 'Alquimia', :label => 'Mutus Liber').count

    assert_empty MetalArchives::Band.search_by(:name => 'SomeNonExistantName')
  end
end
