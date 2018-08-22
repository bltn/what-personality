class PersonalityModelController < ApplicationController

  require 'net/http'
  require 'uri'
  require 'json'
  include PersonalityModelHelper
  
  def new
  end
  
  def create
    parsed_watson_api_uri = URI.parse("https://gateway.watsonplatform.net/personality-insights/api/v3/profile?version=2017-10-13")
    
    response = send_post_request(parsed_watson_api_uri, params[:author_text])
    json_personality_objects = JSON.parse(response.body)
    
    set_session_data(json_personality_objects, params[:author_text])
    
    redirect_to '/personality_model' 
  end 
  
  def show
    @traits = session["big_5_traits_hash"]
    @needs = session["needs_hash"]
    @values = session["values_hash"]
    @author_text = session["author_text"]
  end 
  
  private
  
  def set_session_data(json_personality_objects, author_text)
    session["big_5_traits_hash"] = json_personality_objects["personality"]
    session["needs_hash"] = json_personality_objects["needs"]
    session["values_hash"] = json_personality_objects["values"]
    session["author_text"] = author_text
  end
  
  def send_post_request(parsed_uri, data)
    header = {
      'Content-Type' => 'text/plain;charset=utf-8',
      'Accept' => 'application/json'
    }
    
    http = Net::HTTP.new(parsed_uri.host, parsed_uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(parsed_uri.request_uri, header)
    request.basic_auth("3cffc0c6-e414-4969-b599-5eddff287ab2", "ZJPy2Anpx1eA")
    request.body = data
    
    http.request(request)
  end
end