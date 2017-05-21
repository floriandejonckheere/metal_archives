# frozen_string_literal: true


RSpec.describe MetalArchives::Range do
  let(:range) { build :range }
  let(:begin_range) { build :range, :end => nil }
  let(:end_range) { build :range, :begin => nil }

  it 'has the correct properties' do
    expect(range).to respond_to :begin
    expect(range).to respond_to :begin=
    expect(range).to respond_to :begin?

    expect(range).to respond_to :end
    expect(range).to respond_to :end=
    expect(range).to respond_to :end?
  end

  it 'returns the correct values' do
    expect(range.begin).not_to be_nil
    expect(range.begin).to be_a Date
    expect(range.begin?).to be true

    expect(range.end).not_to be_nil
    expect(range.end).to be_a Date
    expect(range.end?).to be true
  end

  it 'does not require an end date' do
    expect(begin_range.end).to be nil
    expect(begin_range.end?).to be false
  end

  it 'does not require a begin date' do
    expect(end_range.begin).to be nil
    expect(end_range.begin?).to be false
  end

  it 'implements the equal operator' do
    range1 = MetalArchives::Range.new(1, 3)
    range2 = MetalArchives::Range.new(1, 3)
    range3 = MetalArchives::Range.new(nil, 3)
    range4 = MetalArchives::Range.new(nil, 3)
    range5 = MetalArchives::Range.new(1, nil)
    range6 = MetalArchives::Range.new(1, nil)

    expect(range1).to eq range2
    expect(range3).to eq range4
    expect(range5).to eq range6
  end
end
