require_relative '../test_helper'

require 'date'
require 'countries'

require 'metal_archives/parsers/parser_helper.rb'

class ParserHelperTest < Test::Unit::TestCase
  def test_parse_country
    assert_equal ISO3166::Country['US'], MetalArchives::Parsers::ParserHelper.parse_country('United States')
    assert_equal ISO3166::Country['DE'], MetalArchives::Parsers::ParserHelper.parse_country('Germany')
    assert_equal ISO3166::Country['BE'], MetalArchives::Parsers::ParserHelper.parse_country('Belgium')
  end

  def test_parse_genre
    assert_equal ['Black', 'Death', 'Power'].sort,
        MetalArchives::Parsers::ParserHelper.parse_genre('Death, Power, Black').sort

    assert_equal ['Black', 'Death', 'Power'].sort,
        MetalArchives::Parsers::ParserHelper.parse_genre('Death, Power, Black').sort

    assert_equal ['Black', 'Death', 'Heavy', 'Power'].sort,
        MetalArchives::Parsers::ParserHelper.parse_genre('Death (early), Heavy/Power Metal, Black (later)').sort

    assert_equal ['Death', 'Power'].sort,
        MetalArchives::Parsers::ParserHelper.parse_genre('        Death       ,      Power   Metal, Power, Power').sort

    assert_equal ['Heavy Power', 'Speed Power'].sort,
        MetalArchives::Parsers::ParserHelper.parse_genre('Heavy/Speed Power Metal').sort

    assert_equal ['Traditional Heavy', 'Traditional Power'].sort,
        MetalArchives::Parsers::ParserHelper.parse_genre('Traditional Heavy/Power Metal').sort

    assert_equal ['Traditional Heavy', 'Traditional Power', 'Classical Heavy', 'Classical Power'].sort,
        MetalArchives::Parsers::ParserHelper.parse_genre('Traditional/Classical Heavy/Power Metal').sort
  end
end
