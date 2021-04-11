# frozen_string_literal: true

RSpec.describe MetalArchives::Band do
  subject(:band) { described_class.new(id: id) }

  it_behaves_like "it is initializable"

  describe "Pathfinder" do
    let(:id) { 122_302 }

    around { |example| VCR.use_cassette("bands/pathfinder", &example) }

    it "has properties" do
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
      expect(band.logo.path).to eq "/images/1/2/2/3/122302_logo.jpg"
      expect(band.photo.path).to eq "/images/1/2/2/3/122302_photo.jpg"
      expect(band.independent).to eq false
    end

    it "has releases" do
      expect(band.releases.map(&:id)).to include(
        190_714, # Pathfinder / Demo 2007
        201_587, # The Beginning
        283_512, # Moonlight Shadow
        280_057, # Beyond the Space, Beyond the Time
        336_125, # Fifth Element
      )
    end

    it "has members" do
      expect(band.members).to include(
        { name: "Arkadiusz Ruth", id: 18_607, current: true, years_active: 2006.., role: "Bass, Orchestrations, Vocals (choirs)" },
        { name: "Karol Mania", id: 18_596, years_active: 2006.., current: true, role: "Guitars, Vocals (choirs)" },
        { name: "Gunsen", id: 18_599, years_active: 2006.., current: true, role: "Guitars, Vocals (choirs)" },
        { name: "Kacper Stachowiak", id: 124_538, years_active: 2011.., current: true, role: "Drums, Narration, Vocals (choirs)" },
        { name: "Kamil Ruth", id: 18_611, years_active: 2006..2011, current: false, role: "Drums" },
      )
    end

    it "has similar bands" do
      expect(band.similar).to include(
        { band: have_attributes(id: 32), score: 79 },
        { band: have_attributes(id: 2_289), score: 55 },
        { band: have_attributes(id: 3_540_382_043), score: 45 },
        { band: have_attributes(id: 8051), score: 32 },
      )
    end

    it "has links" do
      expect(band.links).to include(
        { type: :official, title: /Arkadiusz/, url: /www.arkadiusz-e-ruth.com/ },
        { type: :official, title: "Facebook", url: /facebook/ },
        { type: :official, title: "Homepage", url: /www.pathfinderband.com/ },
        { type: :official_merchandise, title: "Amazon", url: /amazon/ },
        { type: :official_merchandise, title: "Google Play", url: /play.google.com/ },
      )
    end
  end

  describe "Rhapsody of Fire" do
    let(:id) { 32 }

    around { |example| VCR.use_cassette("bands/rhapsody_of_fire", &example) }

    it "has properties" do
      expect(band.name).to eq "Rhapsody of Fire"
      expect(band.aliases).to match_array %w(Thundercross Rhapsody)
      expect(band.country).to eq ISO3166::Country["IT"]
      expect(band.location).to eq "Trieste, Friuli-Venezia Giulia"
      expect(band.date_formed).to eq Date.new(1995)
      expect(band.years_active).to eq [1993..1995, 1995..2006, 2006..]
      expect(band.status).to eq :active
      expect(band.genres).to eq ["Symphonic Power"]
      expect(band.lyrical_themes).to match_array ["Fantasy", "Epic battles", "Tales"]
      expect(band.comment).to match(/Luca Turilli/)
      expect(band.logo.path).to eq "/images/3/2/32_logo.jpg"
      expect(band.photo.path).to eq "/images/3/2/32_photo.jpg"
      expect(band.independent).to eq false
    end

    it "has releases" do
      expect(band.releases.map(&:id)).to include(
        107, # Legendary Tales
        109, # Symphony of Enchanted Lands
        110, # Dawn of Victory
        451, # Rain of a Thousand Flames
      )
    end

    it "has members" do
      expect(band.members).to include(
        { name: "Alex Staropoli", id: 2003, current: true, years_active: 1995.., role: "Keyboards, Piano, Harpsichord, Orchestrations, Vocals (choirs)" },
        { name: "Giacomo Voli", id: 311_086, current: true, years_active: 2016.., role: "Vocals" },
        { name: "Luca Turilli", id: 2001, current: false, years_active: 1995..2011, role: "Guitars" },
      )
    end

    it "has similar bands" do
      expect(band.similar).to include(
        { band: have_attributes(id: 3_540_348_143), score: 162 },
        { band: have_attributes(id: 388), score: 155 },
        { band: have_attributes(id: 568), score: 90 },
      )
    end

    it "has links" do
      expect(band.links).to include(
        { type: :official, title: "Facebook", url: /facebook/ },
        { type: :official, title: "Homepage", url: /www.rhapsodyoffire.com/ },
        { type: :official_merchandise, title: "Amazon", url: /amazon/ },
        { type: :tablatures, title: "911Tabs", url: /911tabs.com/ },
      )
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
        expect(-> { described_class.find! 0 }).to raise_error MetalArchives::Errors::NotFoundError
        expect(-> { described_class.find! nil }).to raise_error MetalArchives::Errors::NotFoundError
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
