require 'spec_helper'

describe "CoveSearch" do
  include CoveSearch
  describe "Index" do
    describe ".search" do
      before(:each) do
        (1..10).each_with_index do |_,index|
          Index.redis.zadd('test:set', index , index)
        end
      end

      it "should throw an exception if on type given" do
        lambda{Index.search}.should raise_error
      end
        
      it "should return 10 items by default" do
        Index.search("test", "set").length.should == 10
      end

      it "should return a limited number of items based on optional argument" do
        Index.search("test", "set", 3).length.should == 3
      end

      it "should grab all matches for query another" do
        Index.redis.zadd("test:another", 11, "blah")
        Index.search("test", "another").should == ["blah"]
      end
    end

    describe ".add" do
      it "should create a new set if one doesn't exist" do
        Index.redis.exists("test:set").should be_false
        Index.add("test", "set", "hello")
        Index.redis.exists("test:set").should be_true
      end
      
      it "should add members to an existing set" do
        Index.add("test", "set", "hello")       
        Index.add("test", "set", "world")
        Index.redis.zrank("test:set", "hello").should be
        Index.redis.zrank("test:set", "world").should be
      end

      it "should increment the count of an existing element" do
        Index.add("test", "set", "hello")
        old_count = Index.redis.zscore("test:set", "hello").to_i
        Index.add("test", "set", "hello")
        Index.redis.zscore("test:set", "hello").to_i.should be > old_count
      end

      it "should increment the count by a custom value" do
        Index.add "test", "set", "hello"
        old_count = Index.redis.zscore("test:set", "hello").to_i
        Index.add("test", "set", "hello", 10)
        Index.redis.zscore("test:set", "hello").to_i.should == 11
      end
    end
  end
end
