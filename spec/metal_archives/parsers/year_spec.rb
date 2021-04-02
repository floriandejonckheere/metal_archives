# frozen_string_literal: true

RSpec.describe MetalArchives::Parsers::Year do
  subject(:parser) { described_class }

  describe ".parse" do
    it "parses year ranges" do
      expect(parser.parse(nil)).to be_nil
      expect(parser.parse("")).to be_nil
      expect(parser.parse("2001")).to eq 2001..2001
      expect(parser.parse("?-2001")).to eq nil..2001
      expect(parser.parse("2001-?")).to eq 2001..nil
      expect(parser.parse("2001-present")).to eq 2001..nil
    end
  end
end
