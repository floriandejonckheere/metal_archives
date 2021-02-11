# frozen_string_literal: true

module MetalArchives
  module Parsers
    ##
    # Date parser
    #
    class Date < Base
      ##
      # Parse a date
      #
      # Returns +Date+
      #
      def self.parse(input)
        ::Date.parse(input)
      rescue ::Date::Error
        components = input
          .split("-")
          .map(&:to_i)
          .reject(&:zero?)
          .compact

        return if components.empty?

        ::Date.new(*components)
      rescue TypeError
        nil
      end
    end
  end
end
