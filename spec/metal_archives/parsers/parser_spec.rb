# frozen_string_literal: true

RSpec.describe MetalArchives::Parsers::Parser do
  describe "#rewrite" do
    before { MetalArchives.config.endpoint = "http://my-http-proxy/" }

    it "rewrites a URL" do
      expect(described_class.rewrite("https://www.metal-archives.com/band/view/id/32").to_s).to eq "http://my-http-proxy/band/view/id/32"
    end
  end

  describe "#parse_genre" do
    it "parses genres" do
      expect(described_class.parse_genre("Death, Power, Black")).to match_array %w(Black Death Power)
      expect(described_class.parse_genre("Death, Power, Black")).to match_array %w(Black Death Power)
      expect(described_class.parse_genre("Death (early), Heavy/Power Metal, Black (later)")).to match_array %w(Black Death Heavy Power)
      expect(described_class.parse_genre("        Death       ,      Power   Metal, Power, Power")).to match_array %w(Death Power)
      expect(described_class.parse_genre("Heavy/Speed Power Metal")).to match_array ["Heavy Power", "Speed Power"]
      expect(described_class.parse_genre("Traditional Heavy/Power Metal")).to match_array ["Traditional Heavy", "Traditional Power"]
      expect(described_class.parse_genre("Traditional/Classical Heavy/Power Metal")).to match_array ["Traditional Heavy", "Traditional Power", "Classical Heavy", "Classical Power"]
    end
  end

  describe "#parse_date" do
    it "parses dates" do
      expect(described_class.parse_date("2001")).to eq Date.new(2001)
      expect(described_class.parse_date("2001-02")).to eq Date.new(2001, 2)
      expect(described_class.parse_date("2001-02-03")).to eq Date.new(2001, 2, 3)

      expect(described_class.parse_date("February 3rd, 2001")).to eq Date.new(2001, 2, 3)
    end

    it "does not parse invalid dates" do
      expect(described_class.parse_date("-")).to be_nil
      expect(described_class.parse_date("foo")).to be_nil
    end
  end

  describe "#parse_year_range" do
    it "parses year ranges" do
      expect(described_class.parse_year_range("2001")).to eq 2001..2001
      expect(described_class.parse_year_range("?-2001")).to eq nil..2001
      expect(described_class.parse_year_range("2001-?")).to eq 2001..nil
      expect(described_class.parse_year_range("2001-present")).to eq 2001..nil
    end
  end
end
