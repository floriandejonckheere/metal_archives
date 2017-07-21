# frozen_string_literal: true

RSpec.describe MetalArchives::Band do
  describe 'properties' do
    it 'Pathfinder has properties' do
      band = MetalArchives::Band.find 122302

      expect(band).to be_instance_of MetalArchives::Band
      expect(band.name).to eq 'Pathfinder'
      expect(band.aliases).to be_empty
      expect(band.country).to eq ISO3166::Country['PL']
      expect(band.location).to eq 'Poznań'
      expect(band.date_formed).to eq MetalArchives::NilDate.new(2006)
      expect(band.date_active).to eq [MetalArchives::Range.new(MetalArchives::NilDate.new(2006), nil)]
      expect(band.status).to eq :active
      expect(band.genres).to eq ['Symphonic Power']
      expect(band.lyrical_themes.sort).to eq ['Fantasy', 'Battles', 'Glory', 'The Four Elements', 'Metal'].sort
      expect(band.comment).to match 'Pathfinder was founded by'
      expect(band.logo).to be_instance_of URI::HTTPS
      expect(band.logo.path).to eq '/images/1/2/2/3/122302_logo.jpg'
      expect(band.photo).to be_instance_of URI::HTTPS
      expect(band.photo.path).to eq '/images/1/2/2/3/122302_photo.jpg'
      expect(band.independent).not_to be true
      expect(band.similar.length).to eq 19
      expect(band.links.length).to eq 15
      expect(band.links.count { |l| l[:type] == :official }).to eq 12
      expect(band.links.count { |l| l[:type] == :merchandise }).to eq 3
      expect(band.links.select { |l| l[:type] == :merchandise }.first[:url]).to eq 'http://www.amazon.com/Fifth-Element-Pathfinder/dp/B007MNNCVW'
      expect(band.links.select { |l| l[:type] == :merchandise }.first[:title]).to eq 'Amazon'

      expect(band.releases.map { |r| r.title }).to match ['Pathfinder / Demo 2007', 'The Beginning', 'Moonlight Shadow', 'Beyond the Space, Beyond the Time', 'Fifth Element']
    end

    it 'Rhapsody of Fire has properties' do
      band = MetalArchives::Band.find 32

      expect(band).to be_instance_of MetalArchives::Band
      expect(band.name).to eq 'Rhapsody of Fire'
      expect(band.aliases).to match %w(Thundercross Rhapsody)
      expect(band.releases.map { |r| r.title }).to match ['Eternal Glory', 'Legendary Tales', 'Emerald Sword', 'Symphony of Enchanted Lands', 'Holy Thunderforce', 'Dawn of Victory', 'Rain of a Thousand Flames', 'Power of the Dragonflame', 'Tales from the Emerald Sword Saga', 'The Dark Secret', 'Symphony of Enchanted Lands II - The Dark Secret', 'The Magic of the Wizard\'s Dream', 'Live in Canada 2005 - The Dark Secret', 'A New Saga Begins', 'Triumph or Agony', 'Demons, Dragons and Warriors', 'Visions from the Enchanted Lands', 'The Frozen Tears of Angels', 'The Cold Embrace of Fear - A Dark Romantic Symphony', 'Aeons of Raging Darkness', 'From Chaos to Eternity', 'Live - From Chaos to Eternity', 'Dark Wings of Steel', 'Live in Atlanta', 'Shining Star', 'Into the Legend', 'When Demons Awake', 'Legendary Years']
    end

    it 'maps status' do
      expect(MetalArchives::Parsers::Band.send(:map_status, nil)).to eq ''
      expect(MetalArchives::Parsers::Band.send(:map_status, :active)).to eq 'Active'
      expect(MetalArchives::Parsers::Band.send(:map_status, :split_up)).to eq 'Split-up'
      expect(MetalArchives::Parsers::Band.send(:map_status, :on_hold)).to eq 'On hold'
      expect(MetalArchives::Parsers::Band.send(:map_status, :unknown)).to eq 'Unknown'
      expect(MetalArchives::Parsers::Band.send(:map_status, :changed_name)).to eq 'Changed name'
      expect(MetalArchives::Parsers::Band.send(:map_status, :disputed)).to eq 'Disputed'

      expect(-> { MetalArchives::Parsers::Band.send(:map_status, :invalid_status) }).to raise_error MetalArchives::Errors::ParserError
    end
  end

  describe 'methods' do
    describe 'find' do
      it 'finds a band' do
        band = MetalArchives::Band.find 3540361100

        expect(band).not_to be_nil
        expect(band).to be_instance_of MetalArchives::Band
        expect(band.id).to eq 3540361100
        expect(band.name).to eq 'Alquimia'
        expect(band.country).to eq ISO3166::Country['ES']

        expect(band.logo).to be_instance_of URI::HTTPS
        expect(band.logo.path).to eq '/images/3/5/4/0/3540361100_logo.gif'

        expect(band.photo).to be_instance_of URI::HTTPS
        expect(band.photo.path).to eq '/images/3/5/4/0/3540361100_photo.jpg'
      end

      it 'lazily loads' do
        band = MetalArchives::Band.find -1

        expect(band).to be_instance_of MetalArchives::Band
      end
    end

    describe 'find!' do
      it 'finds a band' do
        band = MetalArchives::Band.find! 3540361100

        expect(band).to be_instance_of MetalArchives::Band
        expect(band.name).to eq 'Alquimia'
      end

      it 'raises on invalid id' do
        expect(-> { MetalArchives::Band.find! -1 }).to raise_error MetalArchives::Errors::APIError
        expect(-> { MetalArchives::Band.find! 0 }).to raise_error MetalArchives::Errors::InvalidIDError
        expect(-> { MetalArchives::Band.find! nil }).to raise_error MetalArchives::Errors::InvalidIDError
      end
    end

    describe 'find_by' do
      it 'finds a band' do
        band = MetalArchives::Band.find_by :name => 'Falconer'

        expect(band).to be_instance_of MetalArchives::Band
        expect(band.id).to eq 74
      end

      it 'returns nil on invalid id' do
        band = MetalArchives::Band.find_by :name => 'SomeNonExistantName'

        expect(band).to be_nil
      end
    end

    describe 'find_by!' do
      it 'finds a band' do
        band = MetalArchives::Band.find_by! :name => 'Falconer'

        expect(band).to be_instance_of MetalArchives::Band
        expect(band.id).to eq 74
      end

      it 'returns nil on invalid id' do
        band = MetalArchives::Band.find_by! :name => 'SomeNonExistantName'

        expect(band).to be_nil
      end
    end

    describe 'search' do
      it 'returns a collection' do
        collection = MetalArchives::Band.search 'Alquimia'

        expect(collection).to be_instance_of MetalArchives::Collection
        expect(collection.first).to be_instance_of MetalArchives::Band
      end

      it 'returns an empty collection' do
        expect(MetalArchives::Band.search 'SomeNoneExistantName').to be_empty
      end

      it 'searches by name' do
        expect(MetalArchives::Band.search_by(:name => 'Alquimia').count).to eq 5
        expect(MetalArchives::Band.search_by(:name => 'Lost Horizon').count).to eq 3
        expect(MetalArchives::Band.search_by(:name => 'Lost Horizon', :exact => true).count).to eq 2
        expect(MetalArchives::Band.search_by(:name => 'Alquimia', :genre => 'Melodic Power').count).to eq 2
      end

      it 'searches by year' do
        expect(MetalArchives::Band.search_by(:name => 'Alquimia', :year => MetalArchives::Range.new(nil, nil)).count).to eq 5
        expect(MetalArchives::Band.search_by(:name => 'Alquimia', :year => MetalArchives::Range.new(Date.new(2013), nil)).count).to eq 1
        expect(MetalArchives::Band.search_by(:name => 'Alquimia', :year => MetalArchives::Range.new(Date.new(2008), Date.new(2008))).count).to eq 1
        expect(MetalArchives::Band.search_by(:name => 'Alquimia', :year => MetalArchives::Range.new(Date.new(2008), Date.new(2013))).count).to eq 2
        expect(MetalArchives::Band.search_by(:name => 'Alquimia', :year => MetalArchives::Range.new(nil, Date.new(2013))).count).to eq 5
      end

      it 'searches by country' do
        expect(MetalArchives::Band.search_by(:name => 'Alquimia', :country => ISO3166::Country['ES']).count).to eq 1
        expect(MetalArchives::Band.search_by(:name => 'Alquimia', :country => ISO3166::Country['AR']).count).to eq 3
        expect(MetalArchives::Band.search_by(:name => 'Alquimia', :country => ISO3166::Country['AR']).count).to eq 3
        expect(MetalArchives::Band.search_by(:name => 'Alquimia', :label => 'Mutus Liber').count).to eq 1
      end
    end

    describe 'all' do
      it 'returns a collection' do
        expect(MetalArchives::Band.all).to be_instance_of MetalArchives::Collection
      end
    end
  end
end
