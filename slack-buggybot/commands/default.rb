module SlackBuggybot
  module Commands
    class Default < SlackRubyBot::Commands::Base
      match(/^(?<buggy>\w*)$/) do |client, data, _match|
        client.say(channel: data.channel, text: 'TODO: print help menu')
      end
    end
  end
end
