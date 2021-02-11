# frozen_string_literal: true

RSpec.describe MetalArchives::Parsers::Parser do
  describe "#rewrite" do
    before { MetalArchives.config.endpoint = "http://my-http-proxy/" }

    it "rewrites a URL" do
      expect(described_class.rewrite("https://www.metal-archives.com/band/view/id/32").to_s).to eq "http://my-http-proxy/band/view/id/32"
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
