# frozen_string_literal: true

module MetalArchives
  ##
  # Date with nullable year, month and day
  #
  # WARNING: No validation on actual date is performed
  #
  class NilDate
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
      raise MetalArchives::Errors::ArgumentError, 'invalid date' unless year?

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
    rescue
      raise MetalArchives::Errors::ArgumentError, 'invalid date'
    end
  end
end
