module MetalArchives
  ##
  # Range which can start and/or end with +nil+
  #
  class Range
    include Comparable

    attr_accessor :begin, :end

    ##
    # Create a new range
    #
    # [+_begin+]
    #     Start of range
    #
    #     Default: +nil+
    #
    # [+_end+]
    #     End of range
    #
    #     Default: +nil+
    #
    def initialize(_begin = nil, _end = nil)
      @begin = _begin
      @end = _end
    end

    ##
    # Whether start of range is present
    #
    def begin?
    !!@begin
    end

    ##
    # Whether end of range is present
    #
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
