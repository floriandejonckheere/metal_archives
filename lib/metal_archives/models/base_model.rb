module MetalArchives
  ##
  # Base model class all models are derived from
  #
  class BaseModel
    ##
    # Generic constructor
    #
    def initialize(hash = {})
      self.class.properties.each do |property|
        instance_variable_set("@#{property}", hash[property] || nil)
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
            raise TypeError, "invalid value #{value.class} for #{name}" unless value.is_a?(opts[:type] || String)
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
        #       An array of possible values
        #
        #   [+multiple+]
        #       Whether or not the property has multiple values (which
        #       turns it into an +Array+ of +type+)
        #
        def enum(name, opts)
          attr_accessor name
          (@properties ||= []) << name

          define_method("#{name}?") do
            !instance_variable_get("@#{name}").nil?
          end

          define_method("#{name}=") do |value|
            raise TypeError, "invalid enum value #{value} for #{name}" unless opts[:values].include?(value)
            instance_variable_set("@#{name}", value)
          end
        end

      private
        def client
          MetalArchives.client
        end
    end
  end
end
