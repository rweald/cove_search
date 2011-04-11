require 'sinatra'
require 'yajl/json_gem'
require 'cove_search'

include CoveSearch

get '/search' do
  query = params[:query]
  docs = Index.search(params[:type], query)
  response = {"query" => query, "results" => docs}
  JSON.generate(response)
end
