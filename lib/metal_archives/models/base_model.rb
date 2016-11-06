module MetalArchives
  ##
  # Base model class all models are derived from
  #
  class BaseModel # :nodoc:
    ##
    # Generic constructor
    #
    def initialize(hash = {})
      self.class.properties.each do |property|
        instance_variable_set("@#{property}", (hash[property] || nil))
      end
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
          attr_accessor name
          (@properties ||= []) << name

          define_method("#{name}?") do
            !instance_variable_get("@#{name}").nil?
          end

          define_method("#{name}=") do |value|
            type = opts[:type] || String
            if opts[:multiple]
              raise TypeError, "invalid type #{value.class}, must be Array for #{name}" unless value.is_a? Array
              value.each do |val|
                raise TypeError, "invalid type #{val.class}, must be #{type} for #{name}" unless val.is_a? type
              end
            else
              raise TypeError, "invalid type #{value.class}, must be #{type} for #{name}" unless value.is_a? type
            end
            instance_variable_set("@#{name}", value)
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

          attr_accessor name
          (@properties ||= []) << name

          define_method("#{name}?") do
            !instance_variable_get("@#{name}").nil?
          end

          define_method("#{name}=") do |value|
            if opts[:multiple]
              raise TypeError, "invalid enum value #{value}, must be Array for #{name}" unless value.is_a? Array
              value.each do |val|
                raise TypeError, "invalid enum value #{val} for #{name}" unless opts[:values].include? val
              end
            else
              raise TypeError, "invalid enum value #{value} for #{name}" unless opts[:values].include? value
            end
            instance_variable_set("@#{name}", value)
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
          opts[:values] = [true, false]
          enum name, opts
        end
    end
  end
end
