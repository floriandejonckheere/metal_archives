require 'spec_helper'

describe MetalArchives.config do
  it 'has a valid configuration' do
    expect(subject.app_name).not_to be_nil
    expect(subject.app_version).not_to be_nil
    expect(subject.app_contact).not_to be_nil
  end
end
