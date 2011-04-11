require "redis"
module CoveSearch
  class Index
    class << self
      attr_accessor :redis
    end

    @redis = Redis.new

    def self.search(type=nil, query=nil, limit=10)
      raise "Missing Constraints. Must specify a type and query" unless (type && query)
      @redis.zrange("#{type}:#{query}", 0, limit - 1)
    end

  end
  
end
