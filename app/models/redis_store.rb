module DataStore
  class RedisStore < Base
    def initialize
      @redis = Redis.new
    end

    def load(key)
      @redis.get(key)
    end

    def store(key,value)
      @redis.set(key, value)
    end

    def delete(key)
      @redis.del(key)
    end

    def glob(pattern, &block)
      keys = @redis.keys(pattern)
      if block_given?
        keys.each do |key|
          yield key
        end
      else
        keys
      end
    end
  end# end RedisStore
end# end DataStore
