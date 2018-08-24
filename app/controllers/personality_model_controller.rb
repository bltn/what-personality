class PersonalityModelController < ApplicationController

  require 'net/http'
  require 'uri'
  require 'json'
  include PersonalityModelHelper
  require 'whats_app_chat_log'
  require 'watson_api'
  
  after_action :clear_session_data, only: [:show]

  def new
  end
  
  def create
    filtered_chat_log = WhatsAppChatLog.filter_by_author(params[:chat_messages], params[:author_name])
    json_personality_objects = WatsonAPI.get_personality_insights_as_json(filtered_chat_log)

    set_session_data(json_personality_objects, filtered_chat_log) unless !json_personality_objects.nil?
    
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
  
  def clear_session_data
    session["big_5_traits_hash"] = nil
    session["needs_hash"] = nil
    session["values_hash"] = nil
    session["chat_messages"] = nil
  end
end