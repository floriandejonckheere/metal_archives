require_relative '../test_helper'

require 'metal_archives/parsers/label'

class LabelParserTest < Test::Unit::TestCase
  def setup
    @label = MetalArchives::Parsers::Label.parse(data_for('nuclear_blast.html'))
  end

  def test_attributes
    assert_equal 'Nuclear Blast Records', @label[:name]
    assert_equal ' Oeschstr. 40
73072 Donzdorf ', @label[:address]
    assert_equal ISO3166::Country['DE'], @label[:country]
    assert_equal ' +49 7162 9280-0 ', @label[:phone]
    #~ assert_equal ['Hardcore', 'Death', 'Power', 'Heavy', 'Thrash', 'Black', 'Grind', 'Progressive', 'Viking'].sort, @label[:specializations].sort
    assert_equal Date.new(1987), @label[:date_founded]
    assert @label[:online_shopping]
    assert_equal [
        {:title => 'Nuclear Blast Records Website', :content => 'http://www.nuclearblast.de/en/shop/index.html'},
        {:title => 'info@nuclearblast.de', :content => 'mailto:info@nuclearblast.de'}
    ], @label[:contact]
    assert_equal :active, @label[:status]
  end

  def test_associations
    omit 'not implemented yet'
    @label = MetalArchives::Parsers::Label.parse(data_for('nuclear_blast.html'))
    # sub@labels
  end
end
