# group_me_bot
A simple GroupMe bot API for Ruby.

Initializing the bot
-----------
```ruby
require "group_me_bot"

bot = GroupMeBot::Bot.new "your_bot_id"
```

Full Initialization Method Signature
---------------------

```ruby
class Bot
	POST_URI = "https://api.groupme.com/v3/bots/post"
	def initialize(bot_id = nil, callback_port = 8080, post_uri = POST_URI)
		...
	end
end
```


The above signature implies that you can pass a custom port for running the callback server, and a different post URI if needed. The post URI should be unchanging.

Sending a Message/Image/Location
-----------------

```ruby
require "group_me_bot"

bot = GroupMeBot::Bot.new "your_bot_id"

bot.send_message "Hello from bot!"

bot.send_image "http://i.imgur.com/O2NQNvP.jpg"

# bot.send_location(long, lat, name)
bot.send_location -77.035268, 8.889709, "Washington Monument"
```
Setting Up Callback Server (for an echo bot)
------------
See [this page](https://dev.groupme.com/tutorials/bots) for groupme.com JSON response details. For some reason, the responses are currently slow. Using TCPServer to make this work. If someone would like to shed a better way to do it, feel free to make a change.

```ruby
# bot- Reference to GroupMe Bot
# response_body- The JSON response sent from groupme.com
bot.run_callback_server do |bot, response_body|
	if response_body["name"] != "bot name"
		bot.send_message response_body["text"]
	end
end
```