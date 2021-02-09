# frozen_string_literal: true

module MetalArchives
  module Cache
    ##
    # Generic LRU memory cache
    #
    class Memory < Base
      def validate!
        raise Errors::InvalidConfigurationError, "size has not been configured" if options[:size].blank?
        raise Errors::InvalidConfigurationError, "size must be a number" unless options[:size].is_a? Integer
      end

      def [](key)
        if keys.include? key
          MetalArchives.config.logger.debug "Cache hit for #{key}"
          keys.delete key
          keys << key
        else
          MetalArchives.config.logger.debug "Cache miss for #{key}"
        end

        cache[key]
      end

      def []=(key, value)
        cache[key] = value

        keys.delete key if keys.include? key

        keys << key

        pop if keys.size > options[:size]
      end

      def clear
        cache.clear
        keys.clear
      end

      def include?(key)
        cache.include?(key)
      end

      def delete(key)
        cache.delete(key)
      end

      private

      def cache
        # Underlying data store
        @cache ||= {}
      end

      def keys
        # Array of keys in order of insertion
        @keys ||= []
      end

      def pop
        to_remove = keys.shift(keys.size - options[:size])

        to_remove.each { |key| cache.delete key }
      end
    end
  end
end
