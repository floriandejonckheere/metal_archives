# frozen_string_literal: true

RSpec.describe MetalArchives::Collection do
  it 'iterates' do
    l = lambda do
      @i ||= 0

      next [] if @i >= 100
      items = (@i .. (@i + 9)).to_a
      @i += 10

      items
    end

    c = MetalArchives::Collection.new l

    i = 0
    c.each do |item|
      expect(item).to eq i
      i += 1
    end
  end

  it 'returns' do
    l = lambda do
      @i ||= 0

      raise StandardError if @i >= 100
      items = (@i .. (@i + 9)).to_a
      @i += 10

      items
    end

    c = MetalArchives::Collection.new l

    i = 0
    c.each do |item|
      break if i == 99
      expect(item).to eq i
      i += 1
    end

    expect(i).to eq 99
  end
end
