require "json"
require "net/http"
require "socket"
require "uri"

module GroupMeBot
  class Bot
    attr_accessor :bot_id, :callback_port, :post_uri
    POST_URI = "https://api.groupme.com/v3/bots/post"
 
    def initialize(bot_id = nil, callback_port = 8080, post_uri = POST_URI)
      @bot_id        = bot_id
      @callback_port = callback_port
      @post_uri      = URI.parse(post_uri)
    end

    def send_message(message)
      req = Net::HTTP::Post.new(self.post_uri, initheader = { "Content-Type" => "application/json" })

      req.body = {
                  "bot_id" => self.bot_id,
                  "text"   => message
                 }.to_json

      res = Net::HTTP.start(self.post_uri.host, self.post_uri.port, :use_ssl => self.post_uri.scheme == "https") do |http|
        http.request(req)
      end
    end

    def send_image(url)
      req = Net::HTTP::Post.new(self.post_uri, initheader = { "Content-Type" => "application/json" })

      req.body = {
                  "bot_id"      => self.bot_id,
                  "attachments" => [{
                                     "type" => "image",
                                     "url"  => url
                                   }]
                 }.to_json

      res = Net::HTTP.start(self.post_uri.host, self.post_uri.port, :use_ssl => self.post_uri.scheme == "https") do |http|
        http.request(req)
      end
    end

    def send_location(long, lat, name)
      req = Net::HTTP::Post.new(self.post_uri, initheader = { "Content-Type" => "application/json" })

      req.body = {
                  "bot_id"      => self.bot_id,
                  "attachments" => [{
                                     "type" => "location",
                                     "lng"  => long.to_s,
                                     "lat"  => lat.to_s,
                                     "name" => name
                                   }]
                 }.to_json

      res = Net::HTTP.start(self.post_uri.host, self.post_uri.port, :use_ssl => self.post_uri.scheme == "https") do |http|
        http.request(req)
      end
    end

    def run_callback_server(&callback_block)
      Thread.start { callback_server(callback_block) }
      puts "Callback server running on port #{self.callback_port}."
    end

    private
    def callback_server(&callback_block)
      server = TCPServer.new("0.0.0.0", self.callback_port)
      loop do
        Thread.start(server.accept) do |client|
          res = []

          while line = client.gets
            res.push(line.chomp)
          end

          client.close
          callback_body = JSON.parse(res.last)
          callback_block.call(callback_body, self)
          res.clear
        end
      end
    end
  end
end
