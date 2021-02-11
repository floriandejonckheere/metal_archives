# frozen_string_literal: true

RSpec.describe MetalArchives::Parsers::Country do
  subject(:parser) { described_class }

  describe ".parse" do
    it "parses countries" do
      expect(parser.parse("United States")).to eq ISO3166::Country["US"]
      expect(parser.parse("Germany")).to eq ISO3166::Country["DE"]
      expect(parser.parse("Belgium")).to eq ISO3166::Country["BE"]
    end
  end
end
