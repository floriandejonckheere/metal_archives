# frozen_string_literal: true

module MetalArchives
  ##
  # Allow objects to be queried
  #
  module Queryable
    extend ActiveSupport::Concern

    class_methods do
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
        return new(id: id) unless respond_to?(:cache_key_for)

        return MetalArchives.cache[cache_key_for(id)] if MetalArchives.cache.include?(cache_key_for(id))

        new(id: id)
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
