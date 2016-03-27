module MetalArchives
  class Range
    include Comparable

    attr_accessor :begin, :end

    def initialize(_begin, _end)
      @begin = _begin
      @end = _end
    end

    def begin?
    !!@begin
    end

    def end?
    !!@end
    end

    def <=>(other)
      comparison = self.begin <=> other.begin

      if comparison == 0
        return self.end <=> other.end
      else
        return comparison
      end
    end
  end
end
