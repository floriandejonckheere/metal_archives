# frozen_string_literal: true

module MetalArchives
  ##
  # Allow objects to define attributes
  #
  module Attributable
    extend ActiveSupport::Concern

    included do
      class_attribute :attributes

      self.attributes = {}
    end

    class_methods do
      ##
      # Define a model attribute
      #
      # [Params]
      # - +name+: +Symbol+, attribute name
      # - +type+: +Symbol+, attribute data type, see rdoc-ref:MetalArchives::Types (default: +:string+)
      # - +multiple+: +Boolean+, whether this attribute represents a collection,
      #               which turns it into an +Enumerable+ of +type+ (default: +false+)
      #
      def attribute(name, type: :string, multiple: false)
        attributes[name] = {
          type: type,
          multiple: multiple,
        }

        define_getter(name)
        define_setter(name)
        define_iffer(name)
      end

      ##
      # Define a getter for an attribute
      #
      # [Params]
      # - +name+: +Symbol+, attribute name
      #
      def define_getter(name)
        define_method(name) do
          # Load only when not loaded or id property
          load! unless loaded? || name == :id

          instance_variable_get(:"@#{name}")
        end
      end

      ##
      # Define a setter for an attribute
      #
      # [Params]
      # - +name+: +Symbol+, attribute name
      #
      def define_setter(name)
        define_method(:"#{name}=") do |value|
          type = Types
            .lookup(attributes[name][:type])

          value = if attributes[name][:multiple]
                    Array(value).map { |v| type.cast(v) }
                  else
                    type.cast(value)
                  end

          instance_variable_set(:"@#{name}", value)
        end
      end

      ##
      # Define an iffer for an attribute
      #
      # [Params]
      # - +name+: +Symbol+, attribute name
      #
      def define_iffer(name)
        define_method(:"#{name}?") do
          send(name).present?
        end
      end
    end
  end
end
