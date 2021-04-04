# frozen_string_literal: true

module MetalArchives
  module Types
    ##
    # Model type
    #
    class Model
      class_attribute :class_name

      def self.cast(value)
        return value if value.is_a? class_name

        class_name.new(id: value)
      end

      def self.serialize(value)
        value&.id
      end

      # rubocop:disable Naming/MethodName
      def self.Type(class_name)
        Class.new(Model) do
          self.class_name = class_name
        end
      end
      # rubocop:enable Naming/MethodName
    end
  end
end

MetalArchives::Types.register(:artist, MetalArchives::Types::Model.Type(MetalArchives::Artist))
MetalArchives::Types.register(:band, MetalArchives::Types::Model.Type(MetalArchives::Band))
MetalArchives::Types.register(:release, MetalArchives::Types::Model.Type(MetalArchives::Release))
