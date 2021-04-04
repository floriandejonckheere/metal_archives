# frozen_string_literal: true

RSpec.describe MetalArchives::Artist do
  describe "properties" do
    it "Alberto Rionda has properties" do
      artist = described_class.find 60_908

      expect(artist).to be_instance_of described_class
      expect(artist.id).to eq 60_908
      expect(artist.name).to eq "Alberto Rionda"
      expect(artist.aliases).to be_empty
      expect(artist.country).to eq ISO3166::Country["ES"]
      expect(artist.location).to eq "Oviedo, Asturias"
      expect(artist.date_of_birth).to eq Date.new(1972, 9, 2)
      expect(artist.gender).to eq :male
      expect(artist.biography).to match "Avalanch"
      expect(artist.trivia).to match "Sanctuarium Estudios"
      expect(URI(artist.photo).path).to eq "/images/6/0/9/0/60908_artist.jpg"

      expect(artist.bands[0]).to eq id: 3_540_361_100,
                                    years_active: 2013..,
                                    role: "Guitars",
                                    active: true

      expect(artist.bands[1]).to eq id: 5795,
                                    years_active: 1994..,
                                    role: "Guitars (lead), Vocals (backing)",
                                    active: true

      expect(artist.bands[2]).to eq name: "Geysser",
                                    years_active: 2009..,
                                    role: "Guitars",
                                    active: false

      expect(artist.bands[3]).to eq name: "Speed Demons",
                                    years_active: 1988..1989,
                                    role: "Guitars",
                                    active: false

      expect(artist.bands[4]).to eq name: "Stunned Parrots",
                                    years_active: 2006..,
                                    role: "Guitars, Keyboards",
                                    active: false
    end

    it "Lemmy Kilmister has properties" do
      artist = described_class.find 260

      expect(artist).to be_instance_of described_class
      expect(artist.name).to eq "Ian Fraser Kilmister"
      expect(artist.aliases).to include "Lemmy Kilmister"
      expect(artist.date_of_death).to eq Date.new(2015, 12, 28)
      expect(artist.links.length).to eq 6
      expect(artist.links.count { |l| l[:type] == :official }).to eq 1
      expect(artist.links.count { |l| l[:type] == :unofficial }).to eq 2
      expect(artist.links.count { |l| l[:type] == :unlisted_bands }).to eq 2
      expect(artist.links.find { |l| l[:type] == :official }[:url]).to eq "https://www.facebook.com/OfficialLemmy"
      expect(artist.links.find { |l| l[:type] == :official }[:title]).to eq "Facebook"

      expect(artist.bands).to include hash_including(name: "Hawkwind",
                                                     years_active: 1971..1975,
                                                     role: "Bass, Vocals (additional)",
                                                     active: false,),
                                      hash_including(name: "Headcat",
                                                     years_active: 2000..2015,
                                                     role: "Bass, Guitars, Vocals",
                                                     active: false,),
                                      hash_including(id: 203,
                                                     years_active: 1975..2015,
                                                     role: "Bass, Vocals",
                                                     active: false,),
                                      hash_including(name: "Opal Butterfly",
                                                     years_active: 1970..1970,
                                                     role: "Guitars",
                                                     active: false,),
                                      hash_including(name: "Sam Gopal",
                                                     years_active: 1968..1968,
                                                     role: "Guitars",
                                                     active: false,),
                                      hash_including(name: "The Motown Sect",
                                                     years_active: 1966..1966,
                                                     role: "Guitars, Vocals",
                                                     active: false,),
                                      hash_including(name: "The Rainmakers",
                                                     years_active: 1963..1966,
                                                     role: "Guitars",
                                                     active: false,),
                                      hash_including(name: "The Rockin' Vickers",
                                                     years_active: 1965..1967,
                                                     role: "Guitars",
                                                     active: false,)
    end

    it "maps query parameters" do
      expect(MetalArchives::Parsers::Artist.map_params(name: "name")[:query]).to eq "name"
    end
  end

  describe "methods" do
    describe "find" do
      it "finds an artist" do
        artist = described_class.find 60_908

        expect(artist).to be_instance_of described_class
        expect(artist.name).to eq "Alberto Rionda"
      end

      it "lazily loads" do
        artist = described_class.find(-1)

        expect(artist).to be_instance_of described_class
      end
    end

    describe "find!" do
      it "finds an artist" do
        artist = described_class.find! 60_908

        expect(artist).to be_instance_of described_class
        expect(artist.name).to eq "Alberto Rionda"
      end

      it "raises on invalid id" do
        expect(-> { described_class.find!(-1) }).to raise_error MetalArchives::Errors::APIError
        expect(-> { described_class.find! 0 }).to raise_error MetalArchives::Errors::InvalidIDError
        expect(-> { described_class.find! nil }).to raise_error MetalArchives::Errors::InvalidIDError
      end
    end

    describe "find_by" do
      it "finds an artist" do
        artist = described_class.find_by name: "Alberto Rionda"

        expect(artist).to be_instance_of described_class
        expect(artist.id).to eq 60_908
      end

      it "returns nil on invalid id" do
        artist = described_class.find_by name: "SomeNonExistantName"

        expect(artist).to be_nil
      end
    end

    describe "find_by!" do
      it "finds an artist" do
        artist = described_class.find_by! name: "Alberto Rionda"

        expect(artist).to be_instance_of described_class
        expect(artist.id).to eq 60_908
      end

      it "returns nil on invalid id" do
        artist = described_class.find_by! name: "SomeNonExistantName"

        expect(artist).to be_nil
      end
    end

    describe "search" do
      it "returns a collection" do
        collection = described_class.search "Alberto Rionda"

        expect(collection).to be_instance_of MetalArchives::Collection
        expect(collection.first).to be_instance_of described_class

        expect(described_class.search("Alberto Rionda").count).to eq 1
        expect(described_class.search("Name").count).to eq 12
        expect(described_class.search("SomeNonExistantName").count).to eq 0
        expect(described_class.search("SomeNonExistantName")).to be_empty
        expect(described_class.search("Filip").count).to be > 200
      end

      it "returns an empty collection" do
        expect(described_class.search("SomeNoneExistantName")).to be_empty
      end
    end

    describe "all" do
      it "returns a collection" do
        expect(described_class.all).to be_instance_of MetalArchives::Collection
      end
    end
  end
end
