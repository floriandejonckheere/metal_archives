module MetalArchives
  ##
  # Base model class all models are derived from
  #
  class BaseModel # :nodoc:
    ##
    # Generic shallow copy constructor
    #
    def initialize(hash = {})
      raise Errors::NotImplementedError, 'no :id property in model' unless self.respond_to? :id?, true

      hash.each do |property, value|
        instance_variable_set("@#{property}", value) if self.class.properties.include? property
      end
    end

    protected
      ##
      # Eagerly fetch the data
      #
      # Raises rdoc-ref:MetalArchives::Errors::APIError
      #
      def fetch
        raise Errors::DataError, 'no id present' unless !!id

        raise Errors::NotImplementedError, 'no :assemble method in model' unless self.respond_to? :assemble, true

        assemble
      end

    class << self
      ##
      # +Array+ of declared properties
      #
      attr_accessor :properties

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
          (@properties ||= []) << name

          # property
          define_method(name) do
            self.fetch unless instance_variable_defined?("@#{name}") or name == :id
            instance_variable_get("@#{name}")
          end

          # property?
          define_method("#{name}?") do
            self.fetch unless instance_variable_defined?("@#{name}") or name == :id

            property = instance_variable_get("@#{name}")
            property.respond_to?(:empty?) ? !property.empty? : !!property
          end

          # property=
          define_method("#{name}=") do
            # Check value type
            type = opts[:type] || String
            if opts[:multiple]
              raise MetalArchives::Errors::TypeError, "invalid type #{value.class}, must be Array for #{name}" unless value.is_a? Array
              value.each do |val|
                raise MetalArchives::Errors::TypeError, "invalid type #{val.class}, must be #{type} for #{name}" unless val.is_a? type
              end
            else
              raise MetalArchives::Errors::TypeError, "invalid type #{value.class}, must be #{type} for #{name}" unless value.is_a? type
            end

            instance_variable_set name, value
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
          raise ArgumentError, 'opts[:values] is required' unless opts and opts[:values]

          (@properties ||= []) << name

          # property
          define_method(name) do
            self.fetch unless instance_variable_defined?("@#{name}")
            instance_variable_get("@#{name}")
          end

          # property?
          define_method("#{name}?") do
            self.fetch unless instance_variable_defined?("@#{name}")

            property = instance_variable_get("@#{name}")
            property.respond_to?(:empty?) ? !property.empty? : !!property
          end

          # property=
          define_method("#{name}=") do |value|
            # Check enum type
            if opts[:multiple]
              raise MetalArchives::Errors::TypeError, "invalid enum value #{value}, must be Array for #{name}" unless value.is_a? Array
              value.each do |val|
                raise MetalArchives::Errors::TypeError, "invalid enum value #{val} for #{name}" unless opts[:values].include? val
              end
            else
              raise MetalArchives::Errors::TypeError, "invalid enum value #{value} for #{name}" unless opts[:values].include? value
            end

            instance_variable_set name, value
          end
        end

        ##
        # Defines a model boolean property. This method is an alias for +enum name, :values => [true, false]+
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
          enum name, opts.merge(:values => [true, false])
        end
    end
  end
end
