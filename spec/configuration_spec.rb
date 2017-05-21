# frozen_string_literal: true

RSpec.describe MetalArchives::Configuration do
  let(:config) { MetalArchives::Configuration.new }

  it 'has the correct properties' do
    expect(subject).to respond_to :app_name
    expect(subject).to respond_to :app_version
    expect(subject).to respond_to :app_contact
    expect(subject).to respond_to :endpoint
    expect(subject).to respond_to :request_rate
    expect(subject).to respond_to :request_timeout
    expect(subject).to respond_to :logger
    expect(subject).to respond_to :cache_size
  end

  it 'has default properties' do
    expect(subject.endpoint).to eq 'http://www.metal-archives.com/'
    expect(subject.logger).not_to be_nil
    expect(subject.cache_size).to be_an Integer
  end

  it 'is invalid on no configuration' do
    expect(-> { MetalArchives::Band.search 'foo' }).to raise_error MetalArchives::Errors::InvalidConfigurationError
  end

  it 'is invalid without app_name' do
    proc = -> do
      MetalArchives.configure do |c|
        c.app_version = MetalArchives::VERSION
        c.app_contact = `git config user.email`.chomp || 'user@example.com'
      end
    end

    expect(proc).to raise_error MetalArchives::Errors::InvalidConfigurationError
  end

  it 'is invalid without app_version' do
    proc = -> do
      MetalArchives.configure do |c|
        c.app_name = 'MetalArchivesGemTestSuite'
        c.app_contact = `git config user.email`.chomp || 'user@example.com'
      end
    end

    expect(proc).to raise_error MetalArchives::Errors::InvalidConfigurationError
  end

  it 'is invalid without app_contact' do
    proc = -> do
      MetalArchives.configure do |c|
        c.app_name = 'MetalArchivesGemTestSuite'
        c.app_version = MetalArchives::VERSION
      end
    end

    expect(proc).to raise_error MetalArchives::Errors::InvalidConfigurationError
  end

  it 'is valid' do
    proc = -> do
      MetalArchives.configure do |c|
        c.app_name = 'MetalArchivesGemTestSuite'
        c.app_version = MetalArchives::VERSION
        c.app_contact = `git config user.email`.chomp || 'user@example.com'
      end
    end

    expect(proc).not_to raise_error
  end
end
