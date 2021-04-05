# frozen_string_literal: true

RSpec.describe MetalArchives::Builders::Base do
  subject(:builder) { described_class.new }

  before { MetalArchives.config.endpoint = nil }

  describe "#uri" do
    it "returns URIs" do
      expect(builder.uri(URI("https://www.metal-archives.com/band/view/id/32")).to_s).to eq "https://www.metal-archives.com/band/view/id/32"
    end

    it "returns nil" do
      expect(builder.uri(nil)).to eq nil
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
      expect(builder.date(nil)).to eq nil
      expect(builder.date("")).to eq nil
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
end
