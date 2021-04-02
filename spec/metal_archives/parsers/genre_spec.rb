# frozen_string_literal: true

RSpec.describe MetalArchives::Parsers::Genre do
  subject(:parser) { described_class }

  describe ".parse" do
    it "parses genres" do
      expect(parser.parse("Death, Power, Black")).to match_array %w(Black Death Power)
      expect(parser.parse("Death, Power, Black")).to match_array %w(Black Death Power)
      expect(parser.parse("Death (early), Heavy/Power Metal, Black (later)")).to match_array %w(Black Death Heavy Power)
      expect(parser.parse("        Death       ,      Power   Metal, Power, Power")).to match_array %w(Death Power)
      expect(parser.parse("Heavy/Speed Power Metal")).to match_array ["Heavy Power", "Speed Power"]
      expect(parser.parse("Traditional Heavy/Power Metal")).to match_array ["Traditional Heavy", "Traditional Power"]
      expect(parser.parse("Traditional/Classical Heavy/Power Metal")).to match_array ["Traditional Heavy", "Traditional Power", "Classical Heavy", "Classical Power"]
      expect(parser.parse("Speed Metal (early); Power Metal (later)")).to match_array %w(Speed Power)
    end
  end
end
