# frozen_string_literal: true

require "redis"

module MetalArchives
  module Cache
    ##
    # Redis-backed cache
    #
    class Redis < Base
      def validate!; end

      def [](key)
        redis.get key
      end

      def []=(key, value)
        redis.set key, value
      end

      def clear
        redis.flushdb
      end

      def include?(key)
        redis.exists? key
      end

      def delete(key)
        redis.del key
      end

      private

      def redis
        @redis ||= ::Redis.new(**options)
      end
    end
  end
end
