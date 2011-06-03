require 'spec_helper'
require 'cove_search/client'
describe CoveSearch::Client do

  describe ".search" do
    it "should issue get request to the cove_search server" do
      Client.expects(:get).with do |path, parameters|
        path == "/search"
        parameters == {:type => "tag", :query => "hello"}
      end.returns("results" => [])
      Client.search(:type => "tag", :query => "hello")
    end
  end

end
