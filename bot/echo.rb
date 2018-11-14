require 'slack-ruby-bot'

class EchoBot < SlackRubyBot::Bot
  command 'echo' do |client, data, match|
    client.say(text: match[:expression], channel: data.channel)
  end
end

EchoBot.run
