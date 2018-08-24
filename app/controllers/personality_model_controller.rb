class PersonalityModelController < ApplicationController

  require 'net/http'
  require 'uri'
  require 'json'
  include PersonalityModelHelper
  require 'whats_app_chat_log'

  def new
  end
  
  def create
    parsed_watson_api_uri = URI.parse("https://gateway.watsonplatform.net/personality-insights/api/v3/profile?version=2017-10-13")
    filtered_chat_log = WhatsAppChatLog.filter_by_author(params[:chat_messages], params[:author_name])
    
    response = send_post_request(parsed_watson_api_uri, filtered_chat_log.join("\n"))
    json_personality_objects = JSON.parse(response.body)
    
    set_session_data(json_personality_objects, filtered_chat_log)
    
    redirect_to '/personality_model' 
  end 
  
  def show
    @traits = session["big_5_traits_hash"]
    @needs = session["needs_hash"]
    @values = session["values_hash"]
    @chat_messages = session["chat_messages"]
  end 
  
  private
  
  def set_session_data(json_personality_objects, chat_messages)
    session["big_5_traits_hash"] = json_personality_objects["personality"]
    session["needs_hash"] = json_personality_objects["needs"]
    session["values_hash"] = json_personality_objects["values"]
    session["chat_messages"] = chat_messages
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