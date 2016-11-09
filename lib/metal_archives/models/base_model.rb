module MetalArchives
  ##
  # Base model class all models are derived from
  #
  class BaseModel # :nodoc:
    ##
    # Generic shallow copy constructor
    #
    def initialize(hash = {})
      hash.each do |property, value|
        if self.class.properties.include? property
          instance_variable_set("@#{property}", value)
          instance_variable_set("@_#{property}", true)
        end
      end
    end

    protected
      ##
      # Retrieve the data
      #
      # Raises rdoc-ref:MetalArchives::Errors::APIError
      #
      def fetch(source_attr)
        raise MetalArchives::Errors::DataError, 'no id present' unless !!id

        url = parser.find_endpoint id

        response = http.get url
        raise MetalArchives::Errors::APIError, response.status if response.status >= 400

        properties = parser.parse_html(response.body)
        initialize(properties)
      end

      ##
      # Retrieve a HTTPClient instance
      #
      def http
        MetalArchives::HTTPClient.client
      end

      ##
      # Retrieve a parser instance
      #
      def parser
        @parser ||= MetalArchives::Parsers.const_get self.class.name.split('::').last
      rescue NameError
        raise MetalArchives::NotImplementedError, "No parser for class #{self.class.name}"
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
            self.fetch(name) unless !!instance_variable_get("@_#{name}") or name == :id
            instance_variable_get("@#{name}")
          end

          # property?
          define_method("#{name}?") do
            self.fetch(name) unless !!instance_variable_get("@_#{name}") or name == :id

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
            instance_variable_set "@_#{name}", true
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
            self.fetch(name) unless !!instance_variable_get("@_#{name}")
            instance_variable_get("@#{name}")
          end

          # property?
          define_method("#{name}?") do
            self.fetch(name) unless !!instance_variable_get("@_#{name}")

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
            instance_variable_set "@_#{name}", true
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
