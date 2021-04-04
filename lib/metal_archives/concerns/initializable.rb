# frozen_string_literal: true

module MetalArchives
  ##
  # Allow objects to be initialized with attributes
  #
  module Initializable
    extend ActiveSupport::Concern

    included do
      ##
      # Initialize object with attributes
      #
      # [Params]
      # - +id+: +Integer+, Metal Archives identifier
      # - +attributes+: +Hash+ of attribute key-values
      #
      def initialize(id:, **attributes)
        set(id: id, **attributes)
      end

      ##
      # Set attributes
      #
      # [Params]
      # - +attributes+: +Hash+ of attribute key-values
      #
      def set(**attributes)
        attributes.each { |key, value| send("#{key}=", value) }
      end

      ##
      # Compare objects based on class and id
      #
      def ==(other)
        other.is_a?(self.class) &&
          id == other.id
      end
    end
  end
end
