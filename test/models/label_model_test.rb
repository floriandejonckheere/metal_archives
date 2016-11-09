require_relative '../test_helper'

require 'metal_archives/models/label'

class LabelModelTest < Test::Unit::TestCase
    def test_attribute_presence
      label = MetalArchives::Label.new

      [:id, :name, :address, :country, :phone, :specializations, :date_founded, :sub_labels, :online_shopping].each do |attr|
        assert_respond_to label, attr
        assert_respond_to label, "#{attr}?"
      end
    end
end
