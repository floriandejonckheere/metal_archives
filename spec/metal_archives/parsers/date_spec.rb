# frozen_string_literal: true

RSpec.describe MetalArchives::Parsers::Date do
  subject(:parser) { described_class }

  describe ".parse" do
    it "parses dates" do
      expect(parser.parse("2001")).to eq Date.new(2001)
      expect(parser.parse("2001-02")).to eq Date.new(2001, 2)
      expect(parser.parse("2001-02-03")).to eq Date.new(2001, 2, 3)

      expect(parser.parse("February 3rd, 2001")).to eq Date.new(2001, 2, 3)
    end

    it "does not parse invalid dates" do
      expect(parser.parse("-")).to be_nil
      expect(parser.parse("foo")).to be_nil
    end
  end
end
