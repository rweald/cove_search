require 'spec_helper'

describe "CoveSearch" do
  describe "AutoComplete" do
    include CoveSearch
    describe ".generate_ngram_index_for_word" do
      it "should create the necessary stubs if they dont already exist" do
        AutoComplete.redis.exists("autocomplete:hel").should be_false
        AutoComplete.generate_ngram_index_for_word("hello", "test:tag")
        AutoComplete.redis.exists("autocomplete:test:tag:hel").should be_true
        AutoComplete.redis.exists("autocomplete:test:tag:hell").should be_true
        AutoComplete.redis.exists("autocomplete:test:tag:hello").should be_true
      end

      it "should add another word to the set if key already exists" do
        AutoComplete.generate_ngram_index_for_word("hello", "test:tag")
        AutoComplete.generate_ngram_index_for_word("helly", "test:tag")
        AutoComplete.redis.zrange("autocomplete:test:tag:hel", 0, 2).should == ["hello", "helly"]
      end

      it "should handle spaces like any other character" do
        AutoComplete.generate_ngram_index_for_word("hello world", "test:tag")
        AutoComplete.redis.zrange("autocomplete:test:tag:hello", 0, 2).should == ["hello world"]
        AutoComplete.redis.zrange("autocomplete:test:tag:hello ", 0, 2).should == ["hello world"]
        AutoComplete.redis.zrange("autocomplete:test:tag:hello w", 0, 2).should == ["hello world"]
      end
    end

    describe ".autocomplete_for_suffix" do
        
      it "should return all the words with the given suffix" do
        AutoComplete.generate_ngram_index_for_word("hello", "test:tag")
        AutoComplete.autocomplete_for_suffix("hel", "test:tag").should == ["hello"]

        AutoComplete.generate_ngram_index_for_word("helly", "test:tag")
        AutoComplete.autocomplete_for_suffix("hel", "test:tag").should == ["hello", "helly"]
      end

      it "should return an empty array if nothing is found" do
        AutoComplete.autocomplete_for_suffix("blah", "test:tag").should == []
      end
    end
    
    describe ".redis_key" do
      it "should return the autocomplete namespaced key" do
        AutoComplete.redis_key("test", "tag:hello").should == "autocomplete:tag:hello:test"
        AutoComplete.redis_key("", "test:tag").should == "autocomplete:test:tag:"
      end
    end
  end
end
