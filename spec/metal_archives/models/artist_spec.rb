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
      expect(artist.date_of_birth).to eq MetalArchives::NilDate.new(1972, 9, 2)
      expect(artist.gender).to eq :male
      expect(artist.biography).to match "Avalanch"
      expect(artist.trivia).to match "Sanctuarium Estudios"
      expect(URI(artist.photo).path).to eq "/images/6/0/9/0/60908_artist.jpg"

      expect(artist.bands[0]).to eq band: MetalArchives::Band.find(3_540_361_100),
                                    date_active: MetalArchives::Range.new(MetalArchives::NilDate.new(2013), nil),
                                    role: "Guitars",
                                    active: true

      expect(artist.bands[1]).to eq band: MetalArchives::Band.find(5795),
                                    date_active: MetalArchives::Range.new(MetalArchives::NilDate.new(1994), nil),
                                    role: "Guitars (lead), Vocals (backing)",
                                    active: true

      expect(artist.bands[2]).to eq band: "Geysser",
                                    date_active: MetalArchives::Range.new(MetalArchives::NilDate.new(2009), nil),
                                    role: "Guitars",
                                    active: false

      expect(artist.bands[3]).to eq band: "Speed Demons",
                                    date_active: MetalArchives::Range.new(MetalArchives::NilDate.new(1988), MetalArchives::NilDate.new(1989)),
                                    role: "Guitars",
                                    active: false

      expect(artist.bands[4]).to eq band: "Stunned Parrots",
                                    date_active: MetalArchives::Range.new(MetalArchives::NilDate.new(2006), nil),
                                    role: "Guitars, Keyboards",
                                    active: false
    end

    it "Lemmy Kilmister has properties" do
      artist = described_class.find 260

      expect(artist).to be_instance_of described_class
      expect(artist.name).to eq "Ian Fraser Kilmister"
      expect(artist.aliases).to include "Lemmy Kilmister"
      expect(artist.date_of_death).to eq MetalArchives::NilDate.new(2015, 12, 28)
      expect(artist.links.length).to eq 6
      expect(artist.links.count { |l| l[:type] == :official }).to eq 1
      expect(artist.links.count { |l| l[:type] == :unofficial }).to eq 2
      expect(artist.links.count { |l| l[:type] == :unlisted_bands }).to eq 2
      expect(artist.links.find { |l| l[:type] == :official }[:url]).to eq "https://www.facebook.com/OfficialLemmy"
      expect(artist.links.find { |l| l[:type] == :official }[:title]).to eq "Facebook"

      expect(artist.bands).to include hash_including(band: "Hawkwind",
                                                     date_active: MetalArchives::Range.new(MetalArchives::NilDate.new(1971), MetalArchives::NilDate.new(1975)),
                                                     role: "Bass, Vocals (additional)",
                                                     active: false,),
                                      hash_including(band: "Headcat",
                                                     date_active: MetalArchives::Range.new(MetalArchives::NilDate.new(2000), MetalArchives::NilDate.new(2015)),
                                                     role: "Bass, Guitars, Vocals",
                                                     active: false,),
                                      hash_including(band: MetalArchives::Band.find(203),
                                                     date_active: MetalArchives::Range.new(MetalArchives::NilDate.new(1975), MetalArchives::NilDate.new(2015)),
                                                     role: "Bass, Vocals",
                                                     active: false,),
                                      hash_including(band: "Opal Butterfly",
                                                     date_active: MetalArchives::Range.new(MetalArchives::NilDate.new(1970), MetalArchives::NilDate.new(1970)),
                                                     role: "Guitars",
                                                     active: false,),
                                      hash_including(band: "Sam Gopal",
                                                     date_active: MetalArchives::Range.new(MetalArchives::NilDate.new(1968), MetalArchives::NilDate.new(1968)),
                                                     role: "Guitars",
                                                     active: false,),
                                      hash_including(band: "The Motown Sect",
                                                     date_active: MetalArchives::Range.new(MetalArchives::NilDate.new(1966), MetalArchives::NilDate.new(1966)),
                                                     role: "Guitars, Vocals",
                                                     active: false,),
                                      hash_including(band: "The Rainmakers",
                                                     date_active: MetalArchives::Range.new(MetalArchives::NilDate.new(1963), MetalArchives::NilDate.new(1966)),
                                                     role: "Guitars",
                                                     active: false,),
                                      hash_including(band: "The Rockin' Vickers",
                                                     date_active: MetalArchives::Range.new(MetalArchives::NilDate.new(1965), MetalArchives::NilDate.new(1967)),
                                                     role: "Guitars",
                                                     active: false,)
    end

    it "maps query parameters" do
      expect(MetalArchives::Parsers::Artist.map_params(name: "name")[:query]).to eq "name"
    end

    it "uses NilDate" do
      artist = described_class.find 35_049

      expect(artist.name).to eq "Johan Johansson"
      expect(artist.date_of_birth).to be_instance_of MetalArchives::NilDate
      expect(artist.date_of_birth).to eq MetalArchives::NilDate.new(1975, nil, nil)
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
