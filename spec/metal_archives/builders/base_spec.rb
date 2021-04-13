# frozen_string_literal: true

RSpec.describe MetalArchives::Builders::Base do
  subject(:builder) { described_class.new }

  before { MetalArchives.config.endpoint = nil }

  describe "#string" do
    it "returns nil" do
      expect(builder.string(nil)).to be_nil
      expect(builder.string("")).to be_nil
    end

    it "returns a string" do
      expect(builder.string("  string  \n")).to eq "string"
    end
  end

  describe "#symbol" do
    it "returns nil" do
      expect(builder.symbol(nil)).to be_nil
      expect(builder.symbol("")).to be_nil
    end

    it "returns a symbol" do
      expect(builder.symbol("  string  \n")).to eq :string
    end
  end

  describe "#id" do
    it "returns nil" do
      expect(builder.id(nil)).to be_nil
      expect(builder.id("")).to be_nil
    end

    it "returns an integer" do
      expect(builder.id("https://www.example.com/view/id/32#tab_all")).to eq 32
    end
  end

  describe "#uri" do
    it "returns URIs" do
      expect(builder.uri(URI("https://www.metal-archives.com/band/view/id/32")).to_s).to eq "https://www.metal-archives.com/band/view/id/32"
    end

    it "returns nil" do
      expect(builder.uri(nil)).to be_nil
    end

    it "parses a URI string" do
      expect(builder.uri("https://www.metal-archives.com/band/view/id/32").to_s).to eq "https://www.metal-archives.com/band/view/id/32"
    end

    context "when an endpoint is set" do
      before { MetalArchives.config.endpoint = "http://my-http-proxy:8080/" }

      it "rewrites URI host and scheme" do
        expect(builder.uri("https://www.metal-archives.com/band/view/id/32").to_s).to eq "http://my-http-proxy:8080/band/view/id/32"
      end
    end
  end

  describe "#date" do
    it "returns dates" do
      expect(builder.date(Date.new(2000, 1, 1))).to eq Date.new(2000, 1, 1)
    end

    it "returns nil" do
      expect(builder.date(nil)).to be_nil
      expect(builder.date("")).to be_nil
      expect(builder.date("-")).to be_nil
      expect(builder.date("foo")).to be_nil
    end

    it "parses dates" do
      expect(builder.date("2001")).to eq Date.new(2001)
      expect(builder.date("2001-02")).to eq Date.new(2001, 2)
      expect(builder.date("2001-02-03")).to eq Date.new(2001, 2, 3)

      expect(builder.date("February 3rd, 2001")).to eq Date.new(2001, 2, 3)
    end
  end

  describe "#year" do
    it "returns ranges" do
      expect(builder.year(2000..2003)).to eq 2000..2003
    end

    it "returns nil" do
      expect(builder.year(nil)).to be_nil
      expect(builder.year("")).to be_nil
    end

    it "parses years" do
      expect(builder.year("2001")).to eq 2001..2001
      expect(builder.year("?-2001")).to eq nil..2001
      expect(builder.year("2001-?")).to eq 2001..nil
      expect(builder.year("2001-present")).to eq 2001..nil
    end
  end

  describe "#years" do
    it "returns nil" do
      expect(builder.years(nil)).to be_nil
      expect(builder.years("")).to be_nil
    end

    it "returns year ranges and aliases" do
      expect(builder.years("1993-1995 (as Thundercross), 1995-2006 (as Rhapsody), 2006-present"))
        .to eq [[1993..1995, 1995..2006, 2006..], %w(Thundercross Rhapsody)]
    end
  end

  describe "#genres" do
    it "returns empty array" do
      expect(builder.genres(nil)).to be_empty
      expect(builder.genres("")).to be_empty
    end

    it "parses genres" do
      expect(builder.genres("Death, Power, Black")).to match_array %w(Black Death Power)
      expect(builder.genres("Death, Power, Black")).to match_array %w(Black Death Power)
      expect(builder.genres("Death (early), Heavy/Power Metal, Black (later)")).to match_array %w(Black Death Heavy Power)
      expect(builder.genres("        Death       ,      Power   Metal, Power, Power")).to match_array %w(Death Power)
      expect(builder.genres("Heavy/Speed Power Metal")).to match_array ["Heavy Power", "Speed Power"]
      expect(builder.genres("Traditional Heavy/Power Metal")).to match_array ["Traditional Heavy", "Traditional Power"]
      expect(builder.genres("Traditional/Classical Heavy/Power Metal")).to match_array ["Traditional Heavy", "Traditional Power", "Classical Heavy", "Classical Power"]
      expect(builder.genres("Speed Metal (early); Power Metal (later)")).to match_array %w(Speed Power)
    end
  end

  describe "#lyrical_themes" do
    it "returns nil" do
      expect(builder.lyrical_themes(nil)).to be_nil
      expect(builder.lyrical_themes("")).to be_nil
    end

    it "parses lyrical themes" do
      expect(builder.lyrical_themes("Fantasy, Sisu")).to match_array %w(Fantasy Sisu)
    end
  end
end
