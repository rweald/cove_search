require 'sinatra/base'
require 'yajl/json_gem'
require 'cove_search'

class SearchServer < Sinatra::Base
  include CoveSearch

  enable :logging

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
  # You can also add an additional parameter called increment that is the value that 
  # you want to increase the tag weight.
  post '/update_index' do
    unless params[:type] && params[:term] && params[:db_id]
      response.status = 401
      return JSON.generate({"status" => "could not index at this time"})
    end
    incrementor = params[:increment] ? params[:increment] : 1
    Index.add(params[:type], params[:term], params[:db_id], incrementor)
    AutoComplete.generate_ngram_index_for_word(params[:term], params[:type])
    JSON.generate({"status" => "successfully indexed item"})
  end


  # Call this api method when you want to get a list of all the 
  # possible autocompletions for a given suffix 
  get '/autocomplete' do
    callback = params.delete("callback")
    json = nil
    unless params[:query] && params[:type]
      response.status = 401
      json = JSON.generate({"status" => "must specify a query"})
    else
      params[:query] = URI.escape(params[:query])
      puts "autocomplete query: #{params[:query]}"
      results = AutoComplete.autocomplete_for_suffix(params[:query], params[:type])   
      json = JSON.generate({"status" => "success", "results" => results})
    end
    if callback
      content_type = :js
      response = "#{callback} (#{json})"
    else
      response = json
    end
  end

  delete '/clear_index' do
    unless params[:type]
      return JSON.generate({"status" => "failure", "message" => "must specify a type to delete"})
    end
    Index.redis.keys("*#{params[:type]}*").map { |k| Index.redis.del k }
    JSON.generate({"status" => "success"})
  end
end
