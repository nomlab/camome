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

    def format_event(e)
      event = {}
      event["id"] = e["id"]
      event["title"] = e["summary"]
      event["start"] = e["start"]["dateTime"] || e["start"]["date"]
      event["end"] = e["end"]["dateTime"] || e["end"]["date"]
      if  e["start"]["date"] then
        event["allDay"] = true
      else
        event["allDay"] = false
      end
      return event
    end# end format event
  end# end RedisStore
end# end DataStore
