# frozen_string_literal: true

module MetalArchives
  ##
  # Generic LRU memory cache
  #
  class LRUCache
    def initialize(size = 100)
      @size = size

      # Underlying data store
      @cache = {}

      # Array of keys in order of insertion
      @keys = []
    end

    def []=(key, value)
      @cache[key] = value

      @keys.delete key if @keys.include? key

      @keys << key

      pop if @keys.size > @size
    end

    def [](key)
      if @keys.include? key
        MetalArchives.config.logger.debug "Cache hit for #{key}"
        @keys.delete key
        @keys << key
      else
        MetalArchives.config.logger.debug "Cache miss for #{key}"
      end

      @cache[key]
    end

    def clear
      @cache.clear
      @keys.clear
    end

    def include?(key)
      @cache.include? key
    end

    def delete(key)
      @cache.delete key
    end

    private

    def pop
      to_remove = @keys.shift @keys.size - @size

      to_remove.each { |key| @cache.delete key }
    end
  end
end
