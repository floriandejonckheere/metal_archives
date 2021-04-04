# frozen_string_literal: true

module MetalArchives
  ##
  # Allow objects to be queried
  #
  module Queryable
    extend ActiveSupport::Concern

    included do
      ##
      # Find by ID
      #
      # [Returns]
      # - An instance of the current model, even if ID is invalid/it does not exist
      #
      # [+id+]
      #     +Integer+
      #
      def find(id)
        return self.class.new(id: id) unless respond_to?(:cached?)

        return MetalArchives.cache[cache_key_for(id)] if MetalArchives.cache.include?(cache_key_for(id))

        self.class.new(id: id)
      end

      ##
      # Find by ID (no lazy loading)
      #
      # [Returns]
      # - An instance of the current model
      #
      # [Raises]
      # - rdoc-ref:MetalArchives::Errors::APIError when receiving a status code >= 400 (except 404)
      #
      # [+id+]
      #     +Integer+
      #
      def find!(id)
        find(id)&.tap(&:load!)
      end
    end
  end
end
