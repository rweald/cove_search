require 'spec_helper'

describe "CoveSearch" do
  describe "Index" do
    describe ".search" do
      before(:each) do
        Index.redis.del 'test:set'
        (1..10).each_with_index do |_,index|
          Index.redis.zadd('test:set', index , index)
        end
      end

      it "should throw an exception if on type given" do
        lambda{CoveSearch::Index.search}.should raise_error
      end
        
      it "should return 10 items by default" do
        CoveSearch::Index.search("test", "set").length.should == 10
      end

      it "should return a limited number of items based on optional argument" do
        CoveSearch::Index.search("test", "set", 3).length.should == 3
      end
    end
  end
end
