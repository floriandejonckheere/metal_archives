# frozen_string_literal: true

module MetalArchives
  ##
  # Allow objects to be initialized with attributes
  #
  module Initializable
    extend ActiveSupport::Concern

    included do
      ##
      # Generic shallow copy constructor
      #
      def initialize(id:, **attributes)
        set(id: id, **attributes)
      end

      ##
      # Set properties
      #
      def set(**attributes)
        attributes.each { |key, value| instance_variable_set(:"@#{key}", value) }
      end

      ##
      # Returns true if two objects have the same type and id
      #
      def ==(other)
        other.is_a?(self.class) &&
          id == other.id
      end
    end
  end
end
