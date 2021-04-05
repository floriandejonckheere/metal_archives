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
end
