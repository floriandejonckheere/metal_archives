# frozen_string_literal: true

module MetalArchives
  module Types
    ##
    # Keep track of type registrations
    #
    class Registry
      attr_reader :registry

      def initialize
        @registry = {}
      end

      ##
      # Look up a type
      #
      # [Params]
      # - +name+: +Symbol+, type name
      #
      # [Returns]
      # - +Type+
      #
      # [Raises]
      # - +KeyError+ when no type was registered with this name
      def lookup(name)
        registry.fetch(name)
      end

      ##
      # Register a type
      #
      # [Params]
      # - +name+: +Symbol+, type name
      # - +type+: +Type+, type class
      #
      def register(name, type)
        registry[name] = type
      end
    end
  end
end
