module DataStore
  def self.create(type, options = {})
    if type = :redis
      return DataStore::RedisStore.new
    else
      raise 'Does not exists #{type} for DataStore'
    end
  end

  class Base
    def load(key)
      raise 'Not implemented'
    end

    def store(key,value)
      raise 'Not implemented'
    end

    def delete(key)
      raise 'Not implemented'
    end

  end# end Base
  dir = File.dirname(__FILE__)
  autoload :RedisStore, "#{dir}/redis_store.rb"
end# end DataStore
