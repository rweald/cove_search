require 'spec_helper'
require 'cove_search/client'
describe CoveSearch::Client do
  include CoveSearch
  describe ".search" do
    it "should issue get request to the cove_search server" do
      Client.expects(:get).with do |path, parameters|
        path == "/search"
        parameters == {:type => "tag", :query => "hello"}
      end.returns("results" => [])
      Client.search(:type => "tag", :query => "hello")
    end

    it "should raise an error if the http request fails" do
      Client.expects(:get).returns()
      lambda { Client.search(:type => "tag", :query => "hello") }.should raise_error
    end
  end

  describe ".update_index" do
    it "should issue a post request to the search server" do
      Client.expects(:post).with do |path, parameters|
        path == "/update_index"
        parameters == {:type => "tag", :term => "hello", :db_id => 1}
      end.returns("status" => "success")
      Client.update_index(:type => "tag", :term => "hello", :db_id => 1)
    end

    it "should raise an error if the http request fails" do
      Client.expects(:post).returns()
      lambda { Client.update_index(:type => "tag", 
                                   :term => "hello", :db_id => 1) }.should raise_error
    end
  end

  describe ".clear_index" do
    it "should make a delete request to server" do
      Client.expects(:delete).returns("status" => "success")
      Client.clear_index "tag"
    end
  end

end
