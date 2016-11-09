require_relative '../test_helper'

require 'metal_archives/models/band'

class BandModelTest < Test::Unit::TestCase
  def test_attribute_presence
    band = MetalArchives::Band.new

    [:id, :name, :aliases, :country, :location, :date_formed, :date_active, :genres, :lyrical_themes, :comment, :status, :label].each do |attr|
      assert_respond_to band, attr
      assert_respond_to band, "#{attr}?"
    end
  end
end
