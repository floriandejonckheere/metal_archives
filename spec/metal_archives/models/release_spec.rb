# frozen_string_literal: true

RSpec.describe MetalArchives::Release do
  subject(:release) { described_class.new(id: id) }

  it_behaves_like "it is initializable"

  describe "Tales of Ancient Prophecies" do
    let(:id) { 416_934 }

    around { |example| VCR.use_cassette("releases/tales_of_ancient_prophecies", &example) }

    it "has properties" do
      expect(release.title).to eq "Tales of Ancient Prophecies"
      expect(release.type).to eq :full_length
      expect(release.date_released).to eq Date.new(2014, 6, 4)
      expect(release.catalog_id).to eq "BLOD091CD"
      expect(release.version_description).to be_nil
      expect(release.format).to eq :cd
      expect(release.limitation).to be_nil
      expect(release.notes).to be_nil
    end

    it "has a band" do
      expect(release.band.id).to eq 3_540_382_043
    end

    it "has a label" do
      expect(release.label.id).to eq 27_402
    end
  end

  describe "...And Oceans" do
    let(:id) { 123_563 }

    around { |example| VCR.use_cassette("releases/and_oceans", &example) }

    it "has properties" do
      expect(release.title).to eq "...and Oceans"
      expect(release.type).to eq :compilation
      expect(release.date_released).to eq Date.new(2001)
      expect(release.catalog_id).to eq "NMLP 025"
      expect(release.version_description).to be_nil
      expect(release.format).to eq :vinyl
      expect(release.limitation).to be_nil
      expect(release.notes).to be_nil
    end

    it "has a band" do
      expect(release.band.id).to eq 231
    end

    it "has a label" do
      expect(release.label.id).to eq 209
    end
  end

  describe "MMXII" do
    let(:id) { 329_691 }

    around { |example| VCR.use_cassette("releases/mmxii", &example) }

    it "has properties" do
      expect(release.title).to eq "MMXII"
      expect(release.type).to eq :full_length
      expect(release.date_released).to eq Date.new(2012, 3, 23)
      expect(release.catalog_id).to eq "SAR010-2 SP"
      expect(release.format).to eq :"2cd"
    end

    it "has a band" do
      expect(release.band.id).to eq 3_540_341_226
    end

    it "has a label" do
      expect(release.label.id).to eq 23_789
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
        expect(-> { described_class.find! 0 }).to raise_error MetalArchives::Errors::NotFoundError
        expect(-> { described_class.find! nil }).to raise_error MetalArchives::Errors::NotFoundError
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
        expect(described_class.search_by(title: "Rhapsody").count).to eq 19
      end
    end

    describe "all" do
      it "returns a collection" do
        expect(described_class.all).to be_instance_of MetalArchives::Collection
      end
    end
  end
end
