module CoveSearch
  class AutoComplete
    
    class << self
      attr_reader :redis
    end
    #setup the connection to redis
    
    if ENV['REDISTOGO_URL']
      uri = URI.parse(ENV["REDISTOGO_URL"])
      rc = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
    else
      rc = Redis.new
    end
    
    @redis = Redis::Namespace.new "search_index", :redis => rc

    def self.generate_ngram_index_for_word(word)
      (2..word.length).each do |i|
        suffix = word[0...i]
        @redis.zincrby(redis_key(suffix), 1, word)
      end
    end

    def self.autocomplete_for_suffix(suffix, limit=5)
      @redis.zrange(redis_key(suffix), 0, limit)
    end

    def self.redis_key(suffix)
      "autocomplete:#{suffix}"
    end

  end
end
