require 'spec_helper'

describe "CoveSearch" do
  describe "AutoComplete" do
    before(:each) do
      include CoveSearch
    end

    describe ".generate_ngram_index_for_word" do
      it "should create the necessary stubs if they dont already exist" do
        AutoComplete.redis.exists("autocomplete:hel").should be_false
        AutoComplete.generate_ngram_index_for_word("hello")
        AutoComplete.redis.exists("autocomplete:hel").should be_true
        AutoComplete.redis.exists("autocomplete:hell").should be_true
        AutoComplete.redis.exists("autocomplete:hello").should be_true
      end

      it "should add another word to the set if key already exists" do
        AutoComplete.generate_ngram_index_for_word("hello")
        AutoComplete.generate_ngram_index_for_word("helly")
        AutoComplete.redis.zrange("autocomplete:hel", 0, 2).should == ["hello", "helly"]
      end
    end

    describe ".autocomplete_for_suffix" do
        
      it "should return all the words with the given suffix" do
        AutoComplete.generate_ngram_index_for_word("hello")
        AutoComplete.autocomplete_for_suffix("hel").should == ["hello"]

        AutoComplete.generate_ngram_index_for_word("helly")
        AutoComplete.autocomplete_for_suffix("hel").should == ["hello", "helly"]
      end

      it "should return an empty array if nothing is found" do
        AutoComplete.autocomplete_for_suffix("blah").should == []
      end
    end
    
    describe ".redis_key" do
      it "should return the autocomplete namespaced key" do
        AutoComplete.redis_key("test").should == "autocomplete:test"
      end
    end
  end
end
