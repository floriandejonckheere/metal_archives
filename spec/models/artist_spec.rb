# frozen_string_literal: true

RSpec.describe MetalArchives::Artist do
  describe 'properties' do
    it 'Alquimia has properties' do
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
end
