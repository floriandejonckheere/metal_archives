module MetalArchives
  class BaseModel

    class << self
      def property(name, args)
        attr_accessor name
      end

      def enum(name, args)
        attr_accessor name
      end
    end
  end
end
