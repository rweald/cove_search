require "redis"
require 'redis-namespace'

module CoveSearch
  class Index
    class << self
      attr_accessor :redis
    end

    if ENV['REDISTOGO_URL']
      uri = URI.parse(ENV["REDISTOGO_URL"])
      rc = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
    else
      rc = Redis.new
    end
    @redis = Redis::Namespace.new "search_index", :redis => rc
    
    def self.search(type=nil, query=nil, limit=10)
      raise "Missing Constraints. Must specify a type and query" unless (type && query)
      @redis.zrevrange("#{type}:#{query}", 0, limit - 1)
    end

    #add an item to our index. The redis key will be scoped by type so the key will have the form
    # type:query. The content stored in the set will be member which represents the info needed 
    # to retrieve the full document on the application server
    def self.add(type=nil, query=nil, member=nil, incremental=1)
      raise "Missing Constraints. Must specify a type,query, or member" unless (type && query && member)
      @redis.zincrby(redis_key(type, query), incremental, member)
    end

    def self.redis_key(type, query)
      "#{type}:#{query}"
    end
  end
end

