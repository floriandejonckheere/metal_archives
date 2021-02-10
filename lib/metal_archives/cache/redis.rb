# frozen_string_literal: true

require "redis"

module MetalArchives
  module Cache
    ##
    # Redis-backed cache
    #
    class Redis < Base
      def initialize(options = {})
        super

        # Default TTL is 1 month
        options[:ttl] ||= (30 * 24 * 60 * 60)
      end

      def validate!; end

      def [](key)
        redis.get key
      end

      def []=(key, value)
        redis.set key, value, ex: options[:ttl]
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
        @redis ||= ::Redis.new(**options.except(:ttl))
      end
    end
  end
end
