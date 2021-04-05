# frozen_string_literal: true

module MetalArchives
  ##
  # Allow objects to be loaded
  #
  module Loadable
    extend ActiveSupport::Concern

    included do
      ##
      # Fetch, parse and load the data
      #
      # [Params]
      # - +force+: load even when already loaded (default: false)
      #
      # [Raises]
      # - rdoc-ref:Errors::APIError when receiving a status code >= 400 (except 404)
      #
      def load!(force: false)
        return if loaded? && !force

        # TODO: remove when all models have migrated from `assemble` method
        if respond_to?(:assemble)
          set(**assemble)
        else
          Builders
            .const_get(self.class.name.demodulize)
            .new(self)
            .build!
        end

        @loaded = true
        cache!
      end

      ##
      # Whether or not the object is currently loaded
      #
      # [Returns]
      # - +Boolean+
      #
      def loaded?
        @loaded ||= false
      end
    end
  end
end
