# frozen_string_literal: true

RSpec.describe MetalArchives::Parsers::Parser do
  describe "#rewrite" do
    before { MetalArchives.config.endpoint = "http://my-http-proxy/" }

    it "rewrites a URL" do
      expect(described_class.rewrite("https://www.metal-archives.com/band/view/id/32").to_s).to eq "http://my-http-proxy/band/view/id/32"
    end
  end
end
