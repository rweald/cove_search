require "redis"
module CoveSearch
  class Index
    class << self
      attr_accessor :redis
    end

    if ENV['REDISTOGO_URL']
      uri = URI.parse(ENV["REDISTOGO_URL"])
      @redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
    else
      @redis = Redis.new
    end

    def self.search(type=nil, query=nil, limit=10)
      raise "Missing Constraints. Must specify a type and query" unless (type && query)
      @redis.zrevrange("#{type}:#{query}", 0, limit - 1)
    end

    def self.add(type=nil, query=nil, member=nil)
      raise "Missing Constraints. Must specify a type,query, or member" unless (type && query && member)
      @redis.zincrby(redis_key(type, query), 1, member)
    end

    def self.redis_key(type, query)
      "#{type}:#{query}"
    end
  end
end

