# frozen_string_literal: true

RSpec.describe MetalArchives::Artist do
  subject(:artist) { described_class.new(id: id) }

  describe "Alberto Rionda" do
    let(:id) { 60_908 }

    around { |example| VCR.use_cassette("artists/alberto_rionda", &example) }

    it "has attributes" do
      expect(artist.name).to eq "Alberto Rionda"
      expect(artist.aliases).to eq []
      expect(artist.country).to eq ISO3166::Country["ES"]
      expect(artist.location).to eq "Oviedo, Asturias"
      expect(artist.date_of_birth).to eq Date.new(1972, 9, 2)
      expect(artist.date_of_death).to be_nil
      expect(artist.cause_of_death).to be_nil
      expect(artist.gender).to eq :male
      expect(artist.biography).to match "Avalanch"
      expect(artist.trivia).to match "Sanctuarium Estudios"
      expect(artist.photo.path).to eq "/images/6/0/9/0/60908_artist.jpg"
    end

    it "has bands" do
      expect(artist.bands).to include(
        { name: "Alquimia", id: 3_540_361_100, years_active: 2013.., role: "Guitars", active: true },
        { name: "Avalanch", id: 5795, years_active: 1994.., role: "Guitars (lead), Vocals (backing)", active: true },
        { name: "Geysser", years_active: 2009.., role: "Guitars", active: false },
        { name: "Speed Demons", years_active: 1988..1989, role: "Guitars", active: false },
        { name: "Stunned Parrots", years_active: 2006.., role: "Guitars, Keyboards", active: false },
      )
    end

    it "has links" do
      expect(artist.links).to include(
        { type: :official, title: "Facebook", url: /facebook/ },
        { type: :official, title: /Bunker Estudios/, url: /bunker_estudios/ },
      )
    end
  end

  describe "Mayhem" do
    let(:id) { 4752 }

    around { |example| VCR.use_cassette("artists/mayhem", &example) }

    it "has attributes" do
      expect(artist.name).to eq "Marco Apostolo"
      expect(artist.aliases).to eq ["Mayhem"]
      expect(artist.country).to eq ISO3166::Country["IT"]
      expect(artist.location).to be_nil
      expect(artist.date_of_birth).to be_nil
      expect(artist.date_of_death).to be_nil
      expect(artist.cause_of_death).to be_nil
      expect(artist.gender).to eq :male
      expect(artist.photo).to be_nil
    end
  end

  describe "Azel Oliver" do
    let(:id) { 613_096 }

    around { |example| VCR.use_cassette("artists/azel_oliver", &example) }

    it "has attributes" do
      expect(artist.name).to eq "Azel Oliver"
      expect(artist.aliases).to be_empty
      expect(artist.country).to eq ISO3166::Country["HN"]
      expect(artist.location).to be_nil
      expect(artist.date_of_birth).to be_nil
      expect(artist.date_of_death).to be_nil
      expect(artist.cause_of_death).to be_nil
      expect(artist.gender).to eq :male
    end
  end

  describe "Lemmy Kilmister" do
    let(:id) { 260 }

    around { |example| VCR.use_cassette("artists/lemmy_kilmister", &example) }

    it "has attributes" do
      expect(artist.name).to eq "Ian Fraser Kilmister"
      expect(artist.aliases).to eq ["Lemmy Kilmister"]
      expect(artist.country).to eq ISO3166::Country["GB"]
      expect(artist.location).to eq "Stoke-on-Trent, England"
      expect(artist.date_of_birth).to eq Date.new(1945, 12, 24)
      expect(artist.date_of_death).to eq Date.new(2015, 12, 28)
      expect(artist.cause_of_death).to include "cancer"
      expect(artist.gender).to eq :male
    end

    it "has links" do
      expect(artist.links).to include(
        { type: :official, title: "Facebook", url: /facebook/ },
        { type: :official_merchandise, title: "Rock Off", url: /rockofftrade/ },
        { type: :unofficial, title: "Wikipedia", url: /wikipedia/ },
        { type: :unofficial, title: "IMDb", url: /imdb/ },
      )
    end

    it "has bands" do
      expect(artist.bands).to include(
        { name: "Hawkwind", years_active: 1971..1975, role: "Bass, Vocals (additional)", active: false },
        { name: "Headcat", years_active: 2000..2015, role: "Bass, Guitars, Vocals", active: false },
        { name: "Motörhead", id: 203, years_active: 1975..2015, role: "Bass, Vocals", active: false },
        { name: "Opal Butterfly", years_active: 1970..1970, role: "Guitars", active: false },
        { name: "Sam Gopal", years_active: 1968..1968, role: "Guitars", active: false },
        { name: "The Damned", years_active: 1978..1979, role: "Bass", active: false },
        { name: "The Motown Sect", years_active: 1966..1966, role: "Guitars, Vocals", active: false },
        { name: "The Rainmakers", years_active: 1963..1966, role: "Guitars", active: false },
        { name: "The Rockin' Vickers", years_active: 1965..1967, role: "Guitars", active: false },
      )
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
        expect(-> { described_class.find! 0 }).to raise_error MetalArchives::Errors::NotFoundError
        expect(-> { described_class.find! nil }).to raise_error MetalArchives::Errors::NotFoundError
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
