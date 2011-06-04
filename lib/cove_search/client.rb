require 'rest-client'
module CoveSearch
  class Client
    class << self
      attr_accessor :host
    end

    @host = "127.0.0.1:5678"

    def self.update_index(parameters)
      response = post("/update_index", parameters)
      raise "Index could not be updated" unless response["status"] =~ /success/
    end

    def self.search(parameters)
      response = get("/search", parameters)
      begin
        return response["results"]
      rescue
        raise "Search query could not be complete"
      end
    end

    def self.clear_index(type)
      response = delete("/clear_index", {"type" => type})
      raise "Index could not be deleted" unless response["status"] =~ /success/
    end

    def self.get(path, parameters)
      uri = "http://" + @host + path + format_query_string(parameters)
      response = RestClient.get uri
      JSON.parse(response)
    end

    def self.post(path, parameters)
      uri = "http://" + @host + path
      response = RestClient.post uri, escape(parameters)
      JSON.parse(response)
    end

    def self.delete(path, parameters)
      uri = "http://" + @host + path + format_query_string(parameters)
      response = RestClient.delete uri
      JSON.parse(response)
    end

    def self.escape(parameters)
      new_hash = Hash.new
      parameters.each do |key,value|
        new_hash[key] = URI.escape(value.to_s.downcase)
      end
      new_hash
    end

    def self.format_query_string(parameters)
      index = 0
      query_string = ""
      parameters.each_pair do |key, value|
        if index == 0
          query_string << "?#{key}=#{URI.escape(value.to_s.downcase)}"
        else
          query_string << "&#{key}=#{URI.escape(value.to_s.downcase)}"
        end
        index += 1
      end
      return query_string
    end
  end
end
