# frozen_string_literal: true

module MetalArchives
  ##
  # Type system
  #
  module Types
    class << self
      ##
      # Type registry
      #
      def registry
        @registry ||= Registry.new
      end

      delegate :lookup, :register, to: :registry
    end
  end
end
