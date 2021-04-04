# frozen_string_literal: true

module MetalArchives
  ##
  # Allow objects to be cached
  #
  module Cacheable
    extend ActiveSupport::Concern

    included do
      ##
      # Whether the object is currently cached
      #
      # [Returns]
      # - +Boolean+
      #
      def cached?
        MetalArchives.cache.include?(cache_key)
      end

      ##
      # Set the current object in cache
      #
      def cache!
        MetalArchives.cache[cache_key] = self
      end

      ##
      # Evict the current object from cache
      #
      def evict!
        MetalArchives.cache.delete(cache_key)
      end

      ##
      # Unique key to identify object in cache
      #
      # [Returns]
      # - +String+
      def cache_key
        self.class.cache_key_for(id)
      end
    end

    class_methods do
      ##
      # Generate unique key to identify object in cache
      #
      # [Params]
      # - +id+: +Integer+
      #
      # [Returns]
      # - +String+
      #
      def cache_key_for(id)
        "#{name.underscore}//#{id}"
      end
    end
  end
end
