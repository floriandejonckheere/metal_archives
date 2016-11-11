require_relative '../test_helper'

##
# Query method testing
#
# If a test fails, please check the online results to make sure it's not
# the content itself that has changed.
#
class BandQueryTest < Test::Unit::TestCase
  def test_find
    band = MetalArchives::Band.find 3540361100

    assert_not_nil band
    assert band.is_a? MetalArchives::Band
    assert_equal 'Alquimia', band.name
    assert_equal ISO3166::Country['ES'], band.country

    assert_match 'http', band.logo
    assert_match 'http', band.photo

    band = MetalArchives::Band.find(2)

    assert band.is_a? MetalArchives::Band
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
    assert_equal 5, MetalArchives::Band.search_by(:name => 'Alquimia').length

    assert_equal 3, MetalArchives::Band.search_by(:name => 'Lost Horizon').length
    assert_equal 2, MetalArchives::Band.search_by(:name => 'Lost Horizon', :exact => true).length

    assert_equal 2, MetalArchives::Band.search_by(:name => 'Alquimia', :genre => 'Melodic Power').length


      countries = MetalArchives::Band.search('Alquimia').map { |a| a.country }.sort

      assert_equal 5, countries.size
      assert countries.include? ISO3166::Country['AR']
      assert countries.include? ISO3166::Country['ES']
      assert countries.include? ISO3166::Country['CL']

    assert_equal 5, MetalArchives::Band.search_by(
              :name => 'Alquimia', :year => MetalArchives::Range.new(nil, nil)).length
    assert_equal 1, MetalArchives::Band.search_by(
              :name => 'Alquimia', :year => MetalArchives::Range.new(Date.new(2013), nil)).length
    assert_equal 1, MetalArchives::Band.search_by(
              :name => 'Alquimia', :year => MetalArchives::Range.new(Date.new(2008), Date.new(2008))).length
    assert_equal 2, MetalArchives::Band.search_by(
              :name => 'Alquimia', :year => MetalArchives::Range.new(Date.new(2008), Date.new(2013))).length
    assert_equal 5, MetalArchives::Band.search_by(
              :name => 'Alquimia', :year => MetalArchives::Range.new(nil, Date.new(2013))).length

    assert_equal 1, MetalArchives::Band.search_by(:name => 'Alquimia', :country => ISO3166::Country['ES']).length
    assert_equal 3, MetalArchives::Band.search_by(:name => 'Alquimia', :country => ISO3166::Country['AR']).length
    assert_equal 3, MetalArchives::Band.search_by(:name => 'Alquimia', :country => ISO3166::Country['AR']).length
    assert_equal 1, MetalArchives::Band.search_by(:name => 'Alquimia', :label => 'Mutus Liber').length

    assert_empty MetalArchives::Band.search_by(:name => 'SomeNonExistantName')

    assert_equal 274, MetalArchives::Band.search_by(:country => ISO3166::Country['CN']).length
  end
end
