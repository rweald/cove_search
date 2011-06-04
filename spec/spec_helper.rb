require "bundler"
Bundler.setup

require "rack/test"
require "rspec"
require "mocha"
require "cove_search"


ENV['RACK_ENV'] = 'test'

Rspec.configure do |config|
  config.include Rack::Test::Methods
  config.mock_with :mocha
  config.before(:each) do
    r = Redis.new
    r.flushall
  end
end

def parse_json_response(&block)
  resp = yield
  @response = JSON.parse(resp.body)
end

