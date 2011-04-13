require 'sinatra'
require 'yajl/json_gem'
require 'cove_search'

include CoveSearch

# You can call this search url to get all the
# documents for the given query
get '/search' do
  query = params[:query]
  begin
    docs = Index.search(params[:type], query)
  rescue
    status = 401
    return JSON.generate({:status => "invalid parameters"})
  end
  response = {"query" => query, "results" => docs}
  JSON.generate(response)
end

#Post the update_index to add some content to our search 
#index. The request must contain the type whic represents 
#the namespace i.e. Tag. Then the name of the term. Plus
#the document_id is the id from the database where you can 
#retrieve the full object.
# Also generate the necessary ngram index so we can autocomplete the term
#EX// post 'update_index', :type => "tag", :term => "doda", :doc_id => 3 
post '/update_index' do
  unless params[:type] && params[:term] && params[:db_id]
    response.status = 401
    return JSON.generate({"status" => "could not index at this time"})
  end
  Index.add(params[:type], params[:term], params[:db_id])
  AutoComplete.generate_ngram_index_for_word(params[:term])
  JSON.generate({"status" => "successfully indexed item"})
end


# Call this api method when you want to get a list of all the 
# possible autocompletions for a given suffix 
get '/autocomplete' do
  unless params[:query]
    return JSON.generate({"status" => "must specify a query"})
  end
  results = AutoComplete.autocomplete_for_suffix(params[:query])   
  JSON.generate({"status" => "success", "results" => results})
end

#post '/update_autocomplete' do
  #unless params[:term]
    #response.status = 401
    #response.body = JSON.generate({"status" => "failure", "notice" => "You need to specify a word to index"})
    #return 
  #end
  #JSON.generate({"status" => "success"})
#end
