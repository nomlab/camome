module DataStore
  class RedisStore < Base
    def initialize
      @redis = Redis.new
    end

    def load(key)
      begin
        h = {}
        separate_key(key) do |k|
          h[k] = JSON.parse(@redis.get(k))
        end
        h
      rescue
        nil
      end
    end

    def store(key,value)
      separate_key(key) do |k|
        @redis.set(k, value)
      end
    end

    def delete(key)
      separate_key(key) do |k|
        @redis.del(k)
      end
    end

    private

    def match_patterns(pattern)
      @redis.keys(pattern)
    end

    def separate_key(key, &block)
      if key["*"] then
        keys = match_patterns(key)
        keys.each do |k|
          yield k
        end
      else
        yield key
      end
    end
  end# end RedisStore
end# end DataStore
