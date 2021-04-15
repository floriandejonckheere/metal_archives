# frozen_string_literal: true

RSpec.describe MetalArchives::Collection do
  subject(:collection) { MetalArchives.Collection(my_class).new("/search/ajax-artist-search/", query: "Alberto+R") }

  let(:my_class) do
    Class.new do
      attr_accessor :id

      def self.find(id)
        @id = id
      end
    end
  end

  use_cassette! "collection"

  describe "#each" do
    it "iterates" do
      expect { |block| collection.each(&block) }.to yield_control.twice
    end
  end

  describe "#length" do
    it "returns the total length" do
      expect(collection.length).to eq 2
    end
  end

  describe "#empty?" do
    it "returns empty" do
      expect(collection).not_to be_empty
    end
  end
end
