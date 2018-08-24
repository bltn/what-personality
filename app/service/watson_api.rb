class WatsonAPI
  def self.get_personality_insights_as_json(chat_log)
    parsed_watson_api_uri = URI.parse("https://gateway.watsonplatform.net/personality-insights/api/v3/profile?version=2017-10-13")
    response = WatsonAPI.send_post_request(parsed_watson_api_uri, chat_log)
    json_personality_objects = JSON.parse(response.body)
  end
  
  private 
  
  def self.send_post_request(parsed_uri, data)
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