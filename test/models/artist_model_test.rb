require_relative '../test_helper'

require 'metal_archives/models/artist'

class ArtistModelTest < Test::Unit::TestCase
  def test_attribute_presence
    artist = MetalArchives::Artist.new

    [:id, :name, :aliases, :country, :location, :date_formed, :date_active, :genres, :lyrical_themes, :comment, :status, :label].each do |attr|
      assert_respond_to artist, attr
    end
  end
end
