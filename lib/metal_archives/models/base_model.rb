require 'byebug'

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

      private
        def property(*args)
          name, opts = args.first, args.last
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

        def enum(name, args)
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

        def client
          MetalArchives.client
        end
    end
  end
end
