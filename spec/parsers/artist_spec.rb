require 'spec_helper'

describe MetalArchives::Parsers::Artist do

  it 'provides an endpoint' do
    expect(MetalArchives::Parsers::Artist.find_endpoint({})).to be_a(String)
  end

end
