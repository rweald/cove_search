require 'spec_helper'
require 'server'

describe "Server" do
  def app
    Sinatra::Application
  end

  describe "GET '/search'" do
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
end
