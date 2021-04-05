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
      # - +multiple+: +Boolean+, whether this attribute represents a collection, which turns it into an +Enumerable+ of +type+ (default: +false+)
      # - +enum+: +Array+ of +String+, restricts value(s) of attribute
      #
      def attribute(name, type: :string, multiple: false, enum: [])
        attributes[name] = {
          type: type,
          multiple: multiple,
          enum: enum,
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
          load! unless !respond_to?(:loaded?) || loaded? || name == :id

          value = instance_variable_get(:"@#{name}")

          return value unless value.blank?

          # Return empty array for empty attributes not set
          attributes[name][:multiple] ? [] : nil
        end
      end

      ##
      # Define a setter for an attribute
      #
      # [Params]
      # - +name+: +Symbol+, attribute name
      #
      # [Raises]
      # - +ArgumentError+ when attribute is typed and value cannot be cast
      # - +ArgumentError+ when attribute is an enum and value is not allowed
      #
      def define_setter(name)
        define_method(:"#{name}=") do |value|
          type = Types
            .lookup(attributes[name][:type])

          # Cast value
          value = if attributes[name][:multiple]
                    Array(value).map { |v| type.cast(v) }
                  else
                    type.cast(value)
                  end

          # Restrict value
          enum = attributes[name][:enum]
          if enum.any?
            if attributes[name][:multiple]
              value.each do |v|
                raise ArgumentError, "#{v} is not included in #{enum}" unless enum.include?(v)
              end
            else
              raise ArgumentError, "#{value} is not included in #{enum}" unless enum.include?(value)
            end
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
