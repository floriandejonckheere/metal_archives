# frozen_string_literal: true

RSpec.describe MetalArchives::Range do
  let(:range) { build :range }
  let(:begin_range) { build :range, end: nil }
  let(:end_range) { build :range, begin: nil }

  it "has the correct properties" do
    expect(range).to respond_to :begin
    expect(range).to respond_to :begin=
    expect(range).to respond_to :begin?

    expect(range).to respond_to :end
    expect(range).to respond_to :end=
    expect(range).to respond_to :end?
  end

  it "returns the correct values" do
    expect(range.begin).not_to be_nil
    expect(range.begin).to be_a Date
    expect(range.begin?).to be true

    expect(range.end).not_to be_nil
    expect(range.end).to be_a Date
    expect(range.end?).to be true
  end

  it "does not require an end date" do
    expect(begin_range.end).to be_nil
    expect(begin_range.end?).to be false
  end

  it "does not require a begin date" do
    expect(end_range.begin).to be_nil
    expect(end_range.begin?).to be false
  end

  it "implements comparable" do
    range1 = described_class.new 1, 3
    range1a = described_class.new 1, 3
    range2 = described_class.new nil, 3
    range2a = described_class.new nil, 3
    range3 = described_class.new 1, nil
    range3a = described_class.new 1, nil

    range4 = described_class.new 1, 4
    range5 = described_class.new 0, 3

    expect(range1 <=> range1a).to eq 0
    expect(range2 <=> range2a).to eq 0
    expect(range3 <=> range3a).to eq 0

    expect(range1 <=> range2).to be_nil
    expect(range2 <=> range3).to be_nil
    expect(range3 <=> range1).to be_nil

    expect(range1 <=> range4).to eq(-1)
    expect(range1 <=> range5).to eq(-1)
    expect(range4 <=> range1).to eq 1
    expect(range5 <=> range1).to eq 1
  end
end
