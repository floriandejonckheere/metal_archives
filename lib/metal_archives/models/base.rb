# frozen_string_literal: true

module MetalArchives
  ##
  # Abstract model class
  #
  class Base
    include Initializable

    ##
    # Fetch, parse and load the data
    #
    # [Raises]
    # - rdoc-ref:Errors::InvalidIDError when no id
    # - rdoc-ref:Errors::APIError when receiving a status code >= 400 (except 404)
    #
    def load!
      raise Errors::InvalidIDError, "no id present" unless id

      # Use constructor to set attributes
      set(**assemble)

      @loaded = true
      MetalArchives.cache[self.class.cache(id)] = self
    rescue StandardError => e
      # Don't cache invalid requests
      MetalArchives.cache.delete self.class.cache(id)
      raise e
    end

    ##
    # Whether or not the object is currently loaded
    #
    def loaded?
      @loaded ||= false
    end

    ##
    # Whether or not the object is currently cached
    #
    def cached?
      loaded? && MetalArchives.cache.include?(self.class.cache(id))
    end

    ##
    # String representation
    #
    def inspect
      "#<#{self.class.name} @id=#{@id} @name=\"#{@name}\">"
    end

    protected

    ##
    # Fetch the data and assemble the model
    #
    # Override this method
    #
    # [Raises]
    # - rdoc-ref:Errors::InvalidIDError when no or invalid id
    # - rdoc-ref:Errors::APIError when receiving a status code >= 400 (except 404)
    #
    def assemble
      raise Errors::NotImplementedError, "method :assemble not implemented"
    end

    class << self
      ##
      # Declared properties
      #
      def properties
        @properties ||= {}
      end

      ##
      # Generate cache key for id
      #
      def cache(id)
        "#{self.class.name}//#{id}"
      end

      protected

      ##
      # Defines a model property.
      #
      # [+name+]
      #     Name of the property
      #
      # [+opts+]
      #   [+type+]
      #       Data type of property (a constant)
      #
      #       Default: +String+
      #
      #   [+multiple+]
      #       Whether or not the property has multiple values (which
      #       turns it into an +Array+ of +type+)
      #
      def property(name, opts = {})
        properties[name] = opts

        # property
        define_method(name) do
          # Load only when not loaded or id property
          load! unless loaded? || name == :id

          instance_variable_get(:"@#{name}")
        end

        # property?
        define_method("#{name}?") do
          send(name).present?
        end

        # property=
        define_method("#{name}=") do |value|
          return instance_variable_set(:"@#{name}", value) if value.nil?

          # Check value type
          type = opts[:type] || String
          if opts[:multiple]
            raise Errors::TypeError, "invalid type #{value.class}, must be Array for #{name}" unless value.is_a? Array

            value.each do |val|
              raise Errors::TypeError, "invalid type #{val.class}, must be #{type} for #{name}" unless val.is_a? type
            end
          else
            raise Errors::TypeError, "invalid type #{value.class}, must be #{type} for #{name}" unless value.is_a? type
          end

          instance_variable_set(:"@#{name}", value)
        end
      end

      ##
      # Defines a model enum property.
      #
      # [+name+]
      #     Name of the property
      #
      # [+opts+]
      #   [+values+]
      #       Required. An array of possible values
      #
      #   [+multiple+]
      #       Whether or not the property has multiple values (which
      #       turns it into an +Array+ of +type+)
      #
      def enum(name, opts)
        raise ArgumentError, "opts[:values] is required" unless opts && opts[:values]

        properties[name] = opts

        # property
        define_method(name) do
          load! unless loaded?

          instance_variable_get(:"@#{name}")
        end

        # property?
        define_method("#{name}?") do
          load! unless loaded? && instance_variable_defined?("@#{name}")

          property = instance_variable_get(:"@#{name}")
          property.respond_to?(:empty?) ? !property.empty? : !property.nil?
        end

        # property=
        define_method("#{name}=") do |value|
          # Check enum type
          if opts[:multiple]
            raise Errors::TypeError, "invalid enum value #{value}, must be Array for #{name}" unless value.is_a? Array

            value.each do |val|
              raise Errors::TypeError, "invalid enum value #{val} for #{name}" unless opts[:values].include? val
            end
          else
            raise Errors::TypeError, "invalid enum value #{value} for #{name}" unless opts[:values].include? value
          end

          instance_variable_set(:"@#{name}", value)
        end
      end

      ##
      # Defines a model boolean property. This method is an alias for <tt>enum name, :values => [true, false]</tt>
      #
      # [+name+]
      #     Name of the property
      #
      # [+opts+]
      #   [+multiple+]
      #       Whether or not the property has multiple values (which
      #       turns it into an +Array+ of +type+)
      #
      def boolean(name, opts = {})
        enum name, opts.merge(values: [true, false])
      end
    end
  end
end
