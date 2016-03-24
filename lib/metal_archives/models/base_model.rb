module MetalArchives
  class BaseModel

    class << self
      private
        def property(*args)
          name = args.first
          opts = args.last
          attr_accessor name
          define_method("#{name}?") do
            !instance_variable_get("@#{name}").nil?
          end

          define_method("#{name}=") do |value|
            raise "invalid type #{type} for #{value.class}" unless value.is_a?(opts[:type] || String)
            instance_variable_set("@#{name}", value)
          end
        end

        def enum(name, args)
          attr_accessor name
        end
    end
  end
end
