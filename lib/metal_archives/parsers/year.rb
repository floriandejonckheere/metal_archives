# frozen_string_literal: true

module MetalArchives
  module Parsers
    ##
    # Year range parser
    #
    class Year < Base
      ##
      # Parse year range
      #
      # Returns +Range+ of +Integer+
      #
      def self.parse(input)
        components = input
          .split("-")
          .map(&:to_i)
          .map { |y| y.zero? ? nil : y }

        return if components.empty?

        # Set end if only one year
        components << components.first if components.count == 1

        components[0]..components[1]
      end
    end
  end
end
