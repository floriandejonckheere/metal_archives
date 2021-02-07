# frozen_string_literal: true

RSpec.describe MetalArchives::Configuration do
  subject(:configuration) { described_class.new }

  describe "properties" do
    it { is_expected.to respond_to :app_name, :app_name= }
    it { is_expected.to respond_to :app_version, :app_version= }
    it { is_expected.to respond_to :app_contact, :app_contact= }
    it { is_expected.to respond_to :endpoint, :endpoint= }
    it { is_expected.to respond_to :endpoint_user, :endpoint_user= }
    it { is_expected.to respond_to :endpoint_password, :endpoint_password= }
    it { is_expected.to respond_to :logger, :logger= }
    it { is_expected.to respond_to :cache_size, :cache_size= }

    it "has default properties" do
      expect(configuration.endpoint).to eq "https://www.metal-archives.com/"
      expect(configuration.logger).not_to be_nil
      expect(configuration.cache_size).to be_an Integer
    end

    it "overrides defaults" do
      configuration.endpoint = "http://my-proxy.com/"
      logger = Logger.new $stderr
      configuration.logger = logger
      configuration.cache_size = 0

      expect(configuration.endpoint).to eq "http://my-proxy.com/"
      expect(configuration.logger).to be logger
      expect(configuration.cache_size).to eq 0
    end
  end

  describe "configuration" do
    it "is invalid without app_name" do
      proc = lambda do
        MetalArchives.configure do |c|
          c.app_version = MetalArchives::VERSION
          c.app_contact = "user@example.com"
        end
      end

      expect(proc).to raise_error MetalArchives::Errors::InvalidConfigurationError
    end

    it "is invalid without app_version" do
      proc = lambda do
        MetalArchives.configure do |c|
          c.app_name = "MetalArchivesGemTestSuite"
          c.app_contact = "user@example.com"
        end
      end

      expect(proc).to raise_error MetalArchives::Errors::InvalidConfigurationError
    end

    it "is invalid without app_contact" do
      proc = lambda do
        MetalArchives.configure do |c|
          c.app_name = "MetalArchivesGemTestSuite"
          c.app_version = MetalArchives::VERSION
        end
      end

      expect(proc).to raise_error MetalArchives::Errors::InvalidConfigurationError
    end

    it "is valid" do
      proc = lambda do
        MetalArchives.configure do |c|
          c.app_name = "MetalArchivesGemTestSuite"
          c.app_version = MetalArchives::VERSION
          c.app_contact = "user@example.com"
        end
      end

      expect(proc).not_to raise_error
    end
  end
end
