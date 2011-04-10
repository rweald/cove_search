require "bundler"
Bundler.setup

require "rack/test"
require "rspec"
require "mocha"
require "cove_search"


ENV['RACK_ENV'] = 'test'

Rspec.configure do |config|
  config.mock_with :mocha
end

