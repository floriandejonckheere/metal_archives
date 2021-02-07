# frozen_string_literal: true

# rubocop:disable RSpec/InstanceVariable
RSpec.describe MetalArchives::Collection do
  subject(:collection) { described_class.new }

  it "iterates" do
    l = lambda do
      @i ||= 0

      next [] if @i >= 100

      items = (@i..(@i + 9)).to_a
      @i += 10

      items
    end

    c = described_class.new l

    i = 0
    c.each do |item|
      expect(item).to eq i
      i += 1
    end
  end

  it "returns" do
    l = lambda do
      @i ||= 0

      raise StandardError if @i >= 100

      items = (@i..(@i + 9)).to_a
      @i += 10

      items
    end

    c = described_class.new l

    i = 0
    c.each do |item|
      break if i == 99

      expect(item).to eq i
      i += 1
    end

    expect(i).to eq 99
  end

  describe "empty?" do
    it "is not empty" do
      l = lambda do
        @i ||= 0

        next [] if @i >= 100

        items = (@i..(@i + 9)).to_a
        @i += 10

        items
      end

      c = described_class.new l

      expect(c).not_to be_empty
    end

    it "is empty" do
      c = described_class.new -> { [] }

      expect(c).to be_empty
    end
  end
end
# rubocop:enable RSpec/InstanceVariable
