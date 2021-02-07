# frozen_string_literal: true

module MetalArchives
  ##
  # Range which can start and/or end with +nil+
  #
  class Range
    include Comparable

    ##
    # Begin- and endpoint of range
    #
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
    def initialize(range_begin = nil, range_end = nil)
      @begin = range_begin
      @end = range_end
    end

    ##
    # Whether start of range is present
    #
    def begin?
      !@begin.nil?
    end

    ##
    # Whether end of range is present
    #
    def end?
      !@end.nil?
    end

    ##
    # Comparison operator
    #
    def <=>(other)
      comp_begin = self.begin <=> other.begin
      comp_end = self.end <=> other.end
      # Return nil if begin or end is uncomparable
      return nil if comp_begin.nil? || comp_end.nil?

      # Compare end if begin is equal
      return comp_end if comp_begin.zero?

      # Compare begin if end is equal
      return comp_begin if comp_begin.zero?

      return nil unless self.begin.is_a?(Integer) && self.end.is_a?(Integer)
      return nil unless other.begin.is_a?(Integer) && other.end.is_a?(Integer)

      # Compare actual range
      (self.end - self.begin) <=> (other.end - other.begin)
    end
  end
end
