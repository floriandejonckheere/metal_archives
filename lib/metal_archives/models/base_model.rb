module MetalArchives
  class BaseModel
    class << self
      private
        def property(*args)
          name, opts = args.first, args.last
          attr_accessor name
          define_method("#{name}?") do
            !instance_variable_get("@#{name}").nil?
          end

          define_method("#{name}=") do |value|
            raise TypeError, "invalid value #{value.class} for #{name}" unless value.is_a?(opts[:type] || String)
            instance_variable_set("@#{name}", value)
          end
        end

        def enum(name, args)
          attr_accessor name
          define_method("#{name}?") do
            !instance_variable_get("@#{name}").nil?
          end

          define_method("#{name}=") do |value|
            raise TypeError, "invalid enum value #{value} for #{name}" unless opts[:values].include?(value)
            instance_variable_set("@#{name}", value)
          end
        end
    end

    private
      def client
        MetalArchives.client
      end
  end
end
