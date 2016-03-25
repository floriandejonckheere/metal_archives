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
            raise "invalid value #{value.class} for #{name}" unless value.is_a?(opts[:type] || String)
            instance_variable_set("@#{name}", value)
          end
        end

        def enum(name, args)
          attr_accessor name
          define_method("#{name}?") do
            !instance_variable_get("@#{name}").nil?
          end

          define_method("#{name}=") do |value|
            raise "invalid enum value #{value} for #{name}" unless opts[:values].include?(value)
            instance_variable_set("@#{name}", value)
          end
        end
    end
  end
end
