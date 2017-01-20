module MetalArchives
  ##
  # Generic LRU memory cache
  #
  class LRUCache
    attr_accessor :size

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
        @keys.delete key
        @keys << key
      end

      @cache[key]
    end

    def clear
      @cache.clear
      @keys.clear
    end

    private
      def pop
        to_remove = @keys.shift @keys.size - @size

        to_remove.each { |key| @cache.delete key }
      end
  end
end
