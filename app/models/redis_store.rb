module DataStore
  class RedisStore < Base
    def initialize
      @redis = Redis.new
    end

    def load(month)
      begin
        JSON.parse(@redis.get(month))
      rescue
        []
      end
    end

    def store(key,value)
      @redis.set(key,value)
    end

    def delete(key)
      @redis.del(key)
    end
  end# end RedisStore
end# end DataStore
