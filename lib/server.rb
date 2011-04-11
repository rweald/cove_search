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

#Post the update_index to add some content to our search 
#index. The request must contain the type whic represents 
#the namespace i.e. Tag. Then the name of the term. Plus
#the document_id is the id from the database where you can 
#retrieve the full object.
#EX// post 'update_index', :type => "tag", :term => "doda", :doc_id => 3 
post '/update_index' do
  unless params[:type] && params[:term] && params[:db_id]
    response.status = 401
    return JSON.generate({"status" => "could not index at this time"})
  end
  Index.add(params[:type], params[:term], params[:db_id])
  JSON.generate({"status" => "successfully indexed item"})
end
