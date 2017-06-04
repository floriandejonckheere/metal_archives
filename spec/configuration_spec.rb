# frozen_string_literal: true

RSpec.describe MetalArchives::Configuration do
  describe 'properties' do
    it 'has the correct properties' do
      expect(subject).to respond_to :app_name
      expect(subject).to respond_to :app_name=
      expect(subject).to respond_to :app_version
      expect(subject).to respond_to :app_version=
      expect(subject).to respond_to :app_contact
      expect(subject).to respond_to :app_contact=
      expect(subject).to respond_to :endpoint
      expect(subject).to respond_to :endpoint=
      expect(subject).to respond_to :default_endpoint
      expect(subject).to respond_to :middleware
      expect(subject).to respond_to :middleware=
      expect(subject).to respond_to :request_rate
      expect(subject).to respond_to :request_rate=
      expect(subject).to respond_to :request_timeout
      expect(subject).to respond_to :request_timeout=
      expect(subject).to respond_to :logger
      expect(subject).to respond_to :logger=
      expect(subject).to respond_to :debug
      expect(subject).to respond_to :debug=
      expect(subject).to respond_to :cache_size
      expect(subject).to respond_to :cache_size=
    end

    it 'has default properties' do
      expect(subject.default_endpoint).to eq 'https://www.metal-archives.com/'
      expect(subject.logger).not_to be_nil
      expect(subject.debug).to be false
      expect(subject.cache_size).to be_an Integer
    end

    it 'overrides defaults' do
      subject.endpoint = 'http://my-proxy.com/'
      logger = Logger.new STDERR
      subject.logger = logger
      subject.debug = true
      subject.cache_size = 0

      expect(subject.endpoint).to eq 'http://my-proxy.com/'
      expect(subject.logger).to be logger
      expect(subject.debug).to be true
      expect(subject.cache_size).to eq 0
    end
  end

  describe 'configuration' do
    after(:each) do
      # Reset configuration
      load 'support/metal_archives.rb'
    end

    it 'is invalid without app_name' do
      proc = -> do
        MetalArchives.configure do |c|
          c.app_version = MetalArchives::VERSION
          c.app_contact = 'user@example.com'
        end
      end

      expect(proc).to raise_error MetalArchives::Errors::InvalidConfigurationError
    end

    it 'is invalid without app_version' do
      proc = -> do
        MetalArchives.configure do |c|
          c.app_name = 'MetalArchivesGemTestSuite'
          c.app_contact = 'user@example.com'
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
          c.app_contact = 'user@example.com'
        end
      end

      expect(proc).not_to raise_error
    end
  end
end
