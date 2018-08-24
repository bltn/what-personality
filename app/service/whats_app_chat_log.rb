class WhatsAppChatLog 
  def self.filter_by_author(chat_log, author_name)
    messages_belonging_to_author = []

    chat_log.each_line do |message|
      unless WhatsAppChatLog.message_not_clean(message) || !WhatsAppChatLog.belongs_to_author(message, author_name)
        without_author_tag = message.partition("#{author_name}: ")[2]
        messages_belonging_to_author << without_author_tag.squish
      end
    end
    messages_belonging_to_author.join("\n")
  end
  
  def self.message_not_clean(msg)
    msg.include?(" omitted>") || msg.include?("http")
  end
  
  def self.belongs_to_author(msg, required_author_name)
    msg.include? "#{required_author_name}: "
  end
end