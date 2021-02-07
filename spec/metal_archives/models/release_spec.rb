# frozen_string_literal: true

RSpec.describe MetalArchives::Release do
  describe "properties" do
    it "Tales of Ancient Prophecies has properties" do
      release = described_class.find 416_934

      expect(release).to be_instance_of described_class
      expect(release.id).to eq 416_934
      expect(release.title).to eq "Tales of Ancient Prophecies"
      expect(release.type).to eq :full_length
      expect(release.date_released).to eq MetalArchives::NilDate.new(2014, 6, 4)
      expect(release.catalog_id).to eq "BLOD091CD"
      expect(release.version_description).to be_nil
      expect(release.format).to eq :cd
      expect(release.limitation).to be_nil
      expect(release.notes).to be_nil
    end

    it "...And Oceans has properties" do
      release = described_class.find 123_563

      expect(release).to be_instance_of described_class
      expect(release.id).to eq 123_563
      expect(release.title).to eq "...and Oceans"
      expect(release.type).to eq :compilation
      expect(release.date_released).to eq MetalArchives::NilDate.new(2000)
      expect(release.catalog_id).to eq "NMLP 025"
      expect(release.version_description).to be_nil
      expect(release.format).to eq :vinyl
      expect(release.limitation).to be_nil
      expect(release.notes).to be_nil
    end

    it "From Chaos To Eternity has multiple cds" do
      release = described_class.find 596_840

      expect(release.format).to eq :cd
    end

    it "Live in Canada 2005 - The Dark Secret has cd format" do
      release = described_class.find 100_770

      expect(release.format).to eq :cd
    end

    it "uses NilDate" do
      release = described_class.find 123_563

      expect(release.title).to eq "...and Oceans"
      expect(release.date_released).to be_instance_of MetalArchives::NilDate
      expect(release.date_released).to eq MetalArchives::NilDate.new(2000, nil, nil)
    end
  end

  describe "methods" do
    describe "find" do
      it "finds a release" do
        release = described_class.find 416_934

        expect(release).not_to be_nil
        expect(release).to be_instance_of described_class
        expect(release.id).to eq 416_934
        expect(release.title).to eq "Tales of Ancient Prophecies"
      end

      it "lazily loads" do
        release = described_class.find(-1)

        expect(release).to be_instance_of described_class
      end
    end

    describe "find!" do
      it "finds a release" do
        release = described_class.find! 416_934

        expect(release).to be_instance_of described_class
        expect(release.title).to eq "Tales of Ancient Prophecies"
      end

      it "raises on invalid id" do
        expect(-> { described_class.find!(-1) }).to raise_error MetalArchives::Errors::APIError
        expect(-> { described_class.find! 0 }).to raise_error MetalArchives::Errors::InvalidIDError
        expect(-> { described_class.find! nil }).to raise_error MetalArchives::Errors::InvalidIDError
      end
    end

    describe "find_by" do
      it "finds a release by title" do
        release = described_class.find_by title: "Tales of Ancient Prophecies"

        expect(release).to be_instance_of described_class
        expect(release.id).to eq 416_934
      end

      it "returns nil on invalid id" do
        release = described_class.find_by title: "SomeNonExistantName"

        expect(release).to be_nil
      end
    end

    describe "find_by!" do
      it "finds a release" do
        release = described_class.find_by! title: "Tales of Ancient Prophecies"

        expect(release).to be_instance_of described_class
        expect(release.id).to eq 416_934
      end

      it "returns nil on invalid id" do
        release = described_class.find_by! title: "SomeNonExistantName"

        expect(release).to be_nil
      end
    end

    describe "search" do
      it "returns a collection" do
        collection = described_class.search "Rhapsody"

        expect(collection).to be_instance_of MetalArchives::Collection
        expect(collection.first).to be_instance_of described_class
      end

      it "returns an empty collection" do
        expect(described_class.search("SomeNoneExistantName")).to be_empty
      end

      it "searches by title" do
        expect(described_class.search_by(title: "Rhapsody").count).to eq 17
        # expect(MetalArchives::Release.search_by(:title => 'Lost Horizon').count).to eq 3
        # expect(MetalArchives::Release.search_by(:title => 'Lost Horizon', :exact => true).count).to eq 2
        # expect(MetalArchives::Release.search_by(:title => 'Alquimia', :genre => 'Melodic Power').count).to eq 2
      end
    end

    describe "all" do
      it "returns a collection" do
        expect(described_class.all).to be_instance_of MetalArchives::Collection
      end
    end
  end
end
