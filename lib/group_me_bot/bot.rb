require 'net/http'

module GroupMeBot
  class Bot
    attr_accessor :bot_id, :post_uri
    POST_URI = "https://api.groupme.com/v3/bots/post"
    
    def initialize(bot_id=nil, post_uri=POST_URI)
      @bot_id   = bot_id
      @post_uri = URI.parse(post_uri)
    end

    def send_message(message)
      payload = {
                  'bot_id' => self.bot_id,
                  'text'   => message
                }
      
      response = Net::HTTP.post_form(self.post_uri, payload)
    end
  end
end
