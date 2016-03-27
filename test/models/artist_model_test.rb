require_relative '../test_helper'

require 'metal_archives/models/artist'

class ArtistModelTest < Test::Unit::TestCase
  def test_basic_attribute_presence
    artist = MetalArchives::Artist.new

    [:id, :name, :aliases, :location, :date_formed, :date_active, :genres, :themes, :comment, :status].each do |attr|
      assert_respond_to artist, attr
    end
  end

  def test_association_presence
    artist = MetalArchives::Artist.new

    [:country, :label].each do |assoc|
      assert_respond_to artist, assoc
    end
  end
end
