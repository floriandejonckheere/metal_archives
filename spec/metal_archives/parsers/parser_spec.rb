# frozen_string_literal: true

RSpec.describe MetalArchives::Parsers::Parser do
  describe "#rewrite" do
    before { MetalArchives.config.endpoint = "http://my-http-proxy/" }

    it "rewrites a URL" do
      expect(described_class.rewrite("https://www.metal-archives.com/band/view/id/32").to_s).to eq "http://my-http-proxy/band/view/id/32"
    end

    describe "#parse_country"
    it "parses countries" do
      expect(described_class.parse_country("United States")).to eq ISO3166::Country["US"]
      expect(described_class.parse_country("Germany")).to eq ISO3166::Country["DE"]
      expect(described_class.parse_country("Belgium")).to eq ISO3166::Country["BE"]
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
end
