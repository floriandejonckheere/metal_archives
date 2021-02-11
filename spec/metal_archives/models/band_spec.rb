# frozen_string_literal: true

RSpec.describe MetalArchives::Band do
  describe "properties" do
    it "Pathfinder has properties" do
      band = described_class.find 122_302

      expect(band).to be_instance_of described_class
      expect(band.name).to eq "Pathfinder"
      expect(band.aliases).to be_empty
      expect(band.country).to eq ISO3166::Country["PL"]
      expect(band.location).to eq "Poznań, Wielkopolskie"
      expect(band.date_formed).to eq Date.new(2006)
      expect(band.years_active).to eq [2006..]
      expect(band.status).to eq :active
      expect(band.genres).to eq ["Symphonic Power"]
      expect(band.lyrical_themes).to match_array %w(Fantasy Sisu)
      expect(band.comment).to match "Pathfinder was founded by"
      expect(URI(band.logo).path).to eq "/images/1/2/2/3/122302_logo.jpg"
      expect(URI(band.photo).path).to eq "/images/1/2/2/3/122302_photo.jpg"
      expect(band.independent).not_to be true
      expect(band.similar.length).to eq 21
      expect(band.links.length).to eq 12
      expect(band.links.count { |l| l[:type] == :official }).to eq 9
      expect(band.links.count { |l| l[:type] == :merchandise }).to eq 3
      expect(band.links.find { |l| l[:type] == :merchandise }[:url]).to eq "https://www.amazon.com/Fifth-Element-Pathfinder/dp/B007MNNCVW"
      expect(band.links.find { |l| l[:type] == :merchandise }[:title]).to eq "Amazon"

      expect(band.releases.map(&:title)).to match ["Pathfinder / Demo 2007", "The Beginning", "Moonlight Shadow", "Beyond the Space, Beyond the Time", "Fifth Element"]
    end

    it "Rhapsody of Fire has properties" do
      band = described_class.find 32

      expect(band).to be_instance_of described_class
      expect(band.name).to eq "Rhapsody of Fire"
      expect(band.aliases).to match %w(Thundercross Rhapsody)
      expect(band.releases.map(&:title)).to match ["Eternal Glory", "Legendary Tales", "Emerald Sword", "Symphony of Enchanted Lands", "Holy Thunderforce", "Dawn of Victory", "Rain of a Thousand Flames", "Power of the Dragonflame", "Tales from the Emerald Sword Saga", "The Dark Secret", "Symphony of Enchanted Lands II: The Dark Secret", "The Magic of the Wizard's Dream", "Live in Canada 2005 - The Dark Secret", "A New Saga Begins", "Triumph or Agony", "Demons, Dragons and Warriors", "Visions from the Enchanted Lands", "The Frozen Tears of Angels", "The Cold Embrace of Fear: A Dark Romantic Symphony", "Aeons of Raging Darkness", "From Chaos to Eternity", "Live - From Chaos to Eternity", "Dark Wings of Steel", "Live in Atlanta", "Shining Star", "Into the Legend", "When Demons Awake", "Land of Immortals", "Knightrider of Doom", "Legendary Years", "The Legend Goes On", "Rain of Fury", "Master of Peace", "The Eighth Mountain"]
    end

    it "maps status" do
      expect(MetalArchives::Parsers::Band.send(:map_status, nil)).to eq ""
      expect(MetalArchives::Parsers::Band.send(:map_status, :active)).to eq "Active"
      expect(MetalArchives::Parsers::Band.send(:map_status, :split_up)).to eq "Split-up"
      expect(MetalArchives::Parsers::Band.send(:map_status, :on_hold)).to eq "On hold"
      expect(MetalArchives::Parsers::Band.send(:map_status, :unknown)).to eq "Unknown"
      expect(MetalArchives::Parsers::Band.send(:map_status, :changed_name)).to eq "Changed name"
      expect(MetalArchives::Parsers::Band.send(:map_status, :disputed)).to eq "Disputed"

      expect(-> { MetalArchives::Parsers::Band.send(:map_status, :invalid_status) }).to raise_error MetalArchives::Errors::ParserError
    end
  end

  describe "methods" do
    describe "find" do
      it "finds a band" do
        band = described_class.find 3_540_361_100

        expect(band).not_to be_nil
        expect(band).to be_instance_of described_class
        expect(band.id).to eq 3_540_361_100
        expect(band.name).to eq "Alquimia"
        expect(band.country).to eq ISO3166::Country["ES"]
        expect(URI(band.logo).path).to eq "/images/3/5/4/0/3540361100_logo.gif"
        expect(URI(band.photo).path).to eq "/images/3/5/4/0/3540361100_photo.jpg"
      end

      it "lazily loads" do
        band = described_class.find(-1)

        expect(band).to be_instance_of described_class
      end
    end

    describe "find!" do
      it "finds a band" do
        band = described_class.find! 3_540_361_100

        expect(band).to be_instance_of described_class
        expect(band.name).to eq "Alquimia"
      end

      it "raises on invalid id" do
        expect(-> { described_class.find!(-1) }).to raise_error MetalArchives::Errors::APIError
        expect(-> { described_class.find! 0 }).to raise_error MetalArchives::Errors::InvalidIDError
        expect(-> { described_class.find! nil }).to raise_error MetalArchives::Errors::InvalidIDError
      end
    end

    describe "find_by" do
      it "finds a band" do
        band = described_class.find_by name: "Falconer"

        expect(band).to be_instance_of described_class
        expect(band.id).to eq 74
      end

      it "returns nil on invalid id" do
        band = described_class.find_by name: "SomeNonExistantName"

        expect(band).to be_nil
      end
    end

    describe "find_by!" do
      it "finds a band" do
        band = described_class.find_by! name: "Falconer"

        expect(band).to be_instance_of described_class
        expect(band.id).to eq 74
      end

      it "returns nil on invalid id" do
        band = described_class.find_by! name: "SomeNonExistantName"

        expect(band).to be_nil
      end
    end

    describe "search" do
      it "returns a collection" do
        collection = described_class.search "Alquimia"

        expect(collection).to be_instance_of MetalArchives::Collection
        expect(collection.first).to be_instance_of described_class
      end

      it "returns an empty collection" do
        expect(described_class.search("SomeNoneExistantName")).to be_empty
      end

      it "searches by name" do
        expect(described_class.search_by(name: "Alquimia").count).to eq 6
        expect(described_class.search_by(name: "Lost Horizon").count).to eq 2
        expect(described_class.search_by(name: "Lost Horizon", exact: true).count).to eq 2
        expect(described_class.search_by(name: "Alquimia", genre: "Melodic Power").count).to eq 2
      end

      it "searches by year" do
        expect(described_class.search_by(name: "Alquimia", year: nil..nil).count).to eq 6
        expect(described_class.search_by(name: "Alquimia", year: 2013..).count).to eq 1
        expect(described_class.search_by(name: "Alquimia", year: 2008..2008).count).to eq 1
        expect(described_class.search_by(name: "Alquimia", year: 2008..2013).count).to eq 2
        expect(described_class.search_by(name: "Alquimia", year: 0..2013).count).to eq 6
      end

      it "searches by country" do
        expect(described_class.search_by(name: "Alquimia", country: ISO3166::Country["ES"]).count).to eq 2
        expect(described_class.search_by(name: "Alquimia", country: ISO3166::Country["AR"]).count).to eq 3
        expect(described_class.search_by(name: "Alquimia", country: ISO3166::Country["AR"]).count).to eq 3
        expect(described_class.search_by(name: "Alquimia", label: "Mutus Liber").count).to eq 1
      end
    end

    describe "all" do
      it "returns a collection" do
        expect(described_class.all).to be_instance_of MetalArchives::Collection
      end
    end
  end
end
