require 'spec_helper'

describe MetalArchives::Artist do

  it 'has the correct methods' do
    expect(subject).to respond_to(:name)
    expect(subject).to respond_to(:name?)
  end

  it 'search returns an array' do
    expect(MetalArchives::Artist.search('Alquimia')).to be_an(Array)
  end

end
