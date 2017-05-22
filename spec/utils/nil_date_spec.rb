# frozen_string_literal: true

RSpec.describe MetalArchives::NilDate do
  let(:date) { build :nil_date }
  let(:date_without_day) { build :nil_date, :day => nil }
  let(:date_without_month) { build :nil_date, :month => nil }

  it 'has the correct properties' do
    expect(date).to respond_to :year
    expect(date).to respond_to :year=
    expect(date).to respond_to :year?

    expect(date).to respond_to :month
    expect(date).to respond_to :month=
    expect(date).to respond_to :month?

    expect(date).to respond_to :day
    expect(date).to respond_to :day=
    expect(date).to respond_to :day?
  end

  it 'returns the correct values' do
    expect(date.year).not_to be_nil
    expect(date.year).to be_an Integer
    expect(date.year?).to be true

    expect(date.month).not_to be_nil
    expect(date.month).to be_an Integer
    expect(date.month?).to be true

    expect(date.day).not_to be_nil
    expect(date.day).to be_an Integer
    expect(date.day?).to be true
  end

  it 'does not require a day' do
    expect(date_without_day.day).to be_nil
    expect(date_without_day.day?).to be false
  end

  it 'does not require a month' do
    expect(date_without_month.month).to be_nil
    expect(date_without_month.month?).to be false
  end

  it 'returns a date' do
    expect(date.date).to be_a Date
    expect(date.date.year).to eq date.year
    expect(date.date.month).to eq date.month
    expect(date.date.day).to eq date.day
  end

  describe 'parsing' do
    it 'parses empty dates' do
      date = described_class.parse ''

      expect(date.year?).to be false
      expect(date.month?).to be false
      expect(date.day?).to be false
    end

    it 'parses dates with year only' do
      date = described_class.parse '2012'

      expect(date.year?).to be true
      expect(date.year).to eq 2012
      expect(date.month?).to be false
      expect(date.day?).to be false
    end

    it 'parses parses dates with year and month' do
      date = described_class.parse '2012-10'

      expect(date.year?).to be true
      expect(date.year).to eq 2012
      expect(date.month?).to be true
      expect(date.month).to eq 10
      expect(date.day?).to be false
    end

    it 'parses full dates' do
      date = described_class.parse '2012-10-02'

      expect(date.year?).to be true
      expect(date.year).to eq 2012
      expect(date.month?).to be true
      expect(date.month).to eq 10
      expect(date.day?).to be true
      expect(date.day).to eq 2
    end

    it 'does not parse on invalid dates' do
      expect(-> { described_class.parse 'October 2nd, 2012' }).to raise_error MetalArchives::Errors::ArgumentError
      expect(-> { described_class.parse 'a-b-c' }).to raise_error MetalArchives::Errors::ArgumentError
      expect(-> { described_class.parse "This isn't a date" }).to raise_error MetalArchives::Errors::ArgumentError
    end
  end
end
