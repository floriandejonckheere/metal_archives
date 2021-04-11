# frozen_string_literal: true

RSpec.describe MetalArchives::Label do
  subject(:label) { described_class.new(id: id) }

  it_behaves_like "it is initializable"

  describe "AFM Records" do
    let(:id) { 17 }

    around { |example| VCR.use_cassette("labels/afm", &example) }

    it "has properties" do
      expect(label.name).to eq "AFM Records"
      expect(label.address).to eq "Agathe-Lasch-Weg 2 22605 Hamburg"
      expect(label.country).to eq ISO3166::Country["DE"]
      expect(label.phone).to eq "+49 (0)40 675 09 788 - 0"
      expect(label.specializations).to match_array %w(Heavy Power Gothic Thrash)
      expect(label.date_founded).to eq Date.new(1995)
      expect(label.status).to eq :active
      expect(label.online_shopping).to eq true
    end

    it "has contacts" do
      expect(label.contact).to include(
        { title: "AFM Records Website", content: /www.afm-records.de/ },
        { title: "ed/sdrocer-mfa//ofni", content: nil },
      )
    end
  end
end
