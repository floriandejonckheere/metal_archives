# frozen_string_literal: true

RSpec.describe MetalArchives::Artist do
  describe 'properties' do
    it 'Alberto Rionda has properties' do
      artist = MetalArchives::Artist.find 60908

      expect(artist).to be_instance_of MetalArchives::Artist
      expect(artist.id).to eq 60908
      expect(artist.name).to eq 'Alberto Rionda'
      expect(artist.aliases).to be_empty
      expect(artist.country).to eq ISO3166::Country['ES']
      expect(artist.location).to eq 'Oviedo, Asturias'
      expect(artist.date_of_birth).to eq Date.new(1972, 9, 2)
      expect(artist.gender).to eq :male
      expect(artist.biography).to match 'Avalanch'
      expect(artist.trivia).to match 'Sanctuarium Estudios'
      expect(artist.photo).to eq URI('https://www.metal-archives.com/images/6/0/9/0/60908_artist.jpg?5002')
    end

    it 'Lemmy Kilmister has properties' do
      artist = MetalArchives::Artist.find 260

      expect(artist).to be_instance_of MetalArchives::Artist
      expect(artist.name).to eq 'Ian Fraser Kilmister'
      expect(artist.aliases).to include 'Lemmy Kilmister'
      expect(artist.date_of_death).to eq Date.new(2015, 12, 28)
      expect(artist.links.length).to eq 5
      expect(artist.links.count { |l| l[:type] == :official }).to eq 1
      expect(artist.links.count { |l| l[:type] == :unofficial }).to eq 2
      expect(artist.links.count { |l| l[:type] == :unlisted_bands }).to eq 2
      expect(artist.links.select { |l| l[:type] == :official }.first[:url]).to eq 'https://www.facebook.com/OfficialLemmy'
      expect(artist.links.select { |l| l[:type] == :official }.first[:title]).to eq 'Facebook'
    end

    it 'maps query parameters' do
      expect(MetalArchives::Parsers::Artist.map_params(:name => 'name')[:query]).to eq 'name'
    end
  end

  describe 'methods' do
    describe 'find' do
      it 'finds an artist' do
        artist = MetalArchives::Artist.find 60908

        expect(artist).to be_instance_of MetalArchives::Artist
        expect(artist.name).to eq 'Alberto Rionda'
      end

      it 'lazily loads' do
        artist = MetalArchives::Artist.find -1

        expect(artist).to be_instance_of MetalArchives::Artist
      end
    end

    describe 'find!' do
      it 'finds an artist' do
        artist = MetalArchives::Artist.find! 60908

        expect(artist).to be_instance_of MetalArchives::Artist
        expect(artist.name).to eq 'Alberto Rionda'
      end

      it 'raises on invalid id' do
        expect(-> { MetalArchives::Artist.find! -1 }).to raise_error MetalArchives::Errors::APIError
        expect(-> { MetalArchives::Artist.find! 0 }).to raise_error MetalArchives::Errors::InvalidIDError
        expect(-> { MetalArchives::Artist.find! nil }).to raise_error MetalArchives::Errors::InvalidIDError
      end
    end

    describe 'find_by' do
      it 'finds an artist' do
        artist = MetalArchives::Artist.find_by :name => 'Alberto Rionda'

        expect(artist).to be_instance_of MetalArchives::Artist
        expect(artist.id).to eq 60908
      end

      it 'returns nil on invalid id' do
        artist = MetalArchives::Artist.find_by :name => 'SomeNonExistantName'

        expect(artist).to be_nil
      end
    end

    describe 'find_by!' do
      it 'finds an artist' do
        artist = MetalArchives::Artist.find_by! :name => 'Alberto Rionda'

        expect(artist).to be_instance_of MetalArchives::Artist
        expect(artist.id).to eq 60908
      end

      it 'returns nil on invalid id' do
        artist = MetalArchives::Artist.find_by! :name => 'SomeNonExistantName'

        expect(artist).to be_nil
      end
    end

    describe 'search' do
      it 'returns a collection' do
        collection = MetalArchives::Artist.search 'Alberto Rionda'

        expect(collection).to be_instance_of MetalArchives::Collection
        expect(collection.first).to be_instance_of MetalArchives::Artist
      end

      it 'returns a collection' do
        expect(MetalArchives::Artist.search('Alberto Rionda').count).to eq 1
        expect(MetalArchives::Artist.search('Name').count).to eq 10
        expect(MetalArchives::Artist.search('SomeNonExistantName').count).to eq 0
        expect(MetalArchives::Artist.search 'SomeNonExistantName').to be_empty
        expect(MetalArchives::Artist.search('Filip').count).to be > 200
      end

      it 'returns an empty collection' do
        expect(MetalArchives::Artist.search 'SomeNoneExistantName').to be_empty
      end
    end

    describe 'all' do
      it 'returns a collection' do
        expect(MetalArchives::Artist.all).to be_instance_of MetalArchives::Collection
      end
    end
  end
end
