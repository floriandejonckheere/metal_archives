# frozen_string_literal: true

require 'date'

module MetalArchives
  ##
  # Date with nullable year, month and day
  #
  # WARNING: No validation on actual date is performed
  #
  class NilDate
    include Comparable

    attr_accessor :year, :month, :day

    def initialize(year = nil, month = nil, day = nil)
      @year = year
      @month = month
      @day = day
    end

    def year?
      !@year.nil?
    end

    def month?
      !@month.nil?
    end

    def day?
      !@day.nil?
    end

    ##
    # Return a +Date+ object
    #
    def date
      raise MetalArchives::Errors::ArgumentError, "Invalid conversion to Date: #{self.to_s}" unless year?

      ::Date.new @year, month || 1, day || 1
    end

    ##
    # Parse YYYY[-MM[-DD]]
    #
    def self.parse(value)
      split = value.split('-')

      year = Integer(split[0]) unless split.empty?
      month = Integer(split[1]) if split.length > 1
      day = Integer(split[2]) if split.length > 2

      return MetalArchives::NilDate.new year, month, day
    rescue => e
      raise MetalArchives::Errors::ArgumentError, "Invalid date: #{value}: #{e}"
    end

    def to_s
      year = (@year || 0).to_s.rjust 2, '0'
      month = (@month || 0).to_s.rjust 2, '0'
      day = (@day || 0).to_s.rjust 2, '0'

      "#{year}-#{month}-#{day}"
    end

    ##
    # Comparison operator
    #
    def <=>(other)
      return nil if other.nil?

      # Return nil if one of the two years is nil
      return nil if (@year.nil? && !other.year.nil?) || !@year.nil? && other.year.nil?

      # Return nil if one of the two months is nil
      return nil if (@month.nil? && !other.month.nil?) || !@month.nil? && other.month.nil?

      # Return nil if one of the two months is nil
      return nil if (@day.nil? && !other.day.nil?) || !@day.nil? && other.day.nil?

      comp_year = @year <=> other.year
      if comp_year == 0
        comp_month = @month <=> other.month
        if comp_month == 0
          return @day <=> other.day
        else
          return comp_month
        end
      else
        comp_year
      end
    end
  end
end
