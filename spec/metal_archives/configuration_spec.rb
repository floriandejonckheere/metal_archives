# frozen_string_literal: true

RSpec.describe MetalArchives::Configuration do
  subject(:configuration) { described_class.new }

  it { is_expected.to respond_to :app_name, :app_name= }
  it { is_expected.to respond_to :app_version, :app_version= }
  it { is_expected.to respond_to :app_contact, :app_contact= }
  it { is_expected.to respond_to :endpoint, :endpoint= }
  it { is_expected.to respond_to :endpoint_user, :endpoint_user= }
  it { is_expected.to respond_to :endpoint_password, :endpoint_password= }
  it { is_expected.to respond_to :logger, :logger= }
  it { is_expected.to respond_to :cache_strategy, :cache_strategy= }
  it { is_expected.to respond_to :cache_options, :cache_options= }

  it "has default properties" do
    expect(configuration.endpoint).to eq "https://www.metal-archives.com/"
    expect(configuration.logger).not_to be_nil
  end

  it "overrides defaults" do
    logger = Logger.new $stderr

    configuration.endpoint = "http://my-proxy.com/"
    configuration.logger = logger

    expect(configuration.endpoint).to eq "http://my-proxy.com/"
    expect(configuration.logger).to be logger
  end

  describe "validate!" do
    it "does not raise when valid" do
      configuration.app_name = "MetalArchivesGemTestSuite"
      configuration.app_version = MetalArchives::VERSION
      configuration.app_contact = "user@example.com"

      expect { configuration.validate! }.not_to raise_error
    end

    it "raises when app_name is blank" do
      configuration.app_name = nil
      configuration.app_version = MetalArchives::VERSION
      configuration.app_contact = "user@example.com"

      expect { configuration.validate! }.to raise_error MetalArchives::Errors::InvalidConfigurationError
    end

    it "raises when app_version is blank" do
      configuration.app_name = "MetalArchivesGemTestSuite"
      configuration.app_version = nil
      configuration.app_contact = "user@example.com"

      expect { configuration.validate! }.to raise_error MetalArchives::Errors::InvalidConfigurationError
    end

    it "raises when app_contact is blank" do
      configuration.app_name = "MetalArchivesGemTestSuite"
      configuration.app_version = MetalArchives::VERSION
      configuration.app_contact = nil

      expect { configuration.validate! }.to raise_error MetalArchives::Errors::InvalidConfigurationError
    end

    it "raises when cache_strategy is blank" do
      configuration.app_name = "MetalArchivesGemTestSuite"
      configuration.app_version = MetalArchives::VERSION
      configuration.app_contact = "user@example.com"
      configuration.cache_strategy = nil

      expect { configuration.validate! }.to raise_error MetalArchives::Errors::InvalidConfigurationError
    end
  end
end
