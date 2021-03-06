require 'spec_helper'
require 'cove_search/server'
require 'cove_search'

describe "Server" do
  def app
    #Sinatra::Application
    SearchServer
  end

  include CoveSearch
  describe "GET '/search'" do
    context "valid query parameters" do
      before(:each) do
        Index.add("tag", "hello", 3)
        @response = get '/search', :query => "hello", :type => "tag"
        @response = JSON.parse(@response.body)
      end
      it "should include query in json response" do
        @response['query'].should == "hello"
      end

      it "should return a list of document that match query" do
        @response['results'].should == ["3"]
      end

    end

    context "no query parameters" do 
      before(:each) do
        get 'search'
      end
      it "should respond with 200" do
        last_response.status.should == 200
      end

      it "should return status 'invalid parameters'" do
        resp = JSON.parse(last_response.body)
        resp['status'].should == "invalid parameters"
      end

    end
  end

  describe "POST '/update_index'" do
    context "unsuccessful update" do
      before(:each) do
        post 'update_index'
      end
      it "should respond with 401 if post body is empty" do
        last_response.status.should == 401
      end
    
      it "should return a could not create index in json with the 401" do
        JSON.parse(last_response.body)['status'].should be
      end
    end

    context "successful update" do
      before(:each) do
        post 'update_index', :type => "tag", :term => "doda", :db_id => 3
      end
      it "should return http success if index updated successfully" do
        last_response.status.should == 200
      end

      it "should return positive status in json on successful update" do
        JSON.parse(last_response.body)['status'].should be
      end
    end
  end


  describe "GET 'autocomplete'" do
    before(:each) do
      AutoComplete.generate_ngram_index_for_word("hello", "test:tag")
    end

    def perform_get(query=nil, type=nil)
      @response = get '/autocomplete', :query => query, :type => type
      @response = JSON.parse(@response.body)
    end

    context "valid query string" do
      before(:each) do
        perform_get('hello', "test:tag")
      end

      it "should respond with 200" do
        last_response.status.should == 200
      end

      it "should return an array of word completions in json" do
        @response['results'].should == ["hello"]
      end
    end
    context "invalid query string" do
      it "should return 401 if no type provided" do
        perform_get("hello")
        last_response.status.should == 401
      end
      it "should return 401 if no query given" do
        perform_get(nil, "test:tag")
        last_response.status.should == 401
      end
    end
  end

  describe "DELETE 'clear_index'" do
    before(:each) do
      Index.add("test:tag", "hello", 1)
    end
    it "should return failure and message if no type given" do
      parse_json_response { delete "clear_index" }
      @response["status"].should == "failure"
      @response["message"].should be
    end

    it "should clear the index if successful" do
      parse_json_response { delete "clear_index", :type => "test:tag" }
      Index.redis.exists("test:tag").should be_false
    end
  end
end
