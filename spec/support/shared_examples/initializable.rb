# frozen_string_literal: true

RSpec.shared_examples "it is initializable" do
  subject(:model) { described_class.new(id: "my_id") }

  it { is_expected.to have_attributes id: "my_id" }
  it { is_expected.not_to eq described_class.new(id: "not_my_id") }

  it "raises when no id is passed on initialization" do
    expect { described_class.new }.to raise_error ArgumentError
  end
end
