require 'spec_helper'
require 'server'

describe "Server" do
  def app
    Sinatra::Application
  end

  describe "GET '/search'" do
    context "valid request" do
      before(:each) do
        @response = get '/search', :query => "hello", :type => "tag"
        @response = JSON.parse(@response.body)
      end
      it "should include query in json response" do
        @response['query'].should == "hello"
      end

      it "should return a list of document that match query" do
        pending "working on index class"
      end
    end
    context "invalid request" do 
      before(:each) do
        get 'search'
      end
      it "should respond with 401" do
        last_response.status.should == 401
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
end
