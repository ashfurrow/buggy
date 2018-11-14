module SlackBuggybot
  module Commands
    class Start < SlackRubyBot::Commands::Base
      command 'start'

      def self.call(client, data, match)
        client.say(channel: data.channel, text: 'starting')
      rescue StandardError => e
        client.say(channel: data.channel, text: "Sorry, #{e.message}.")
      end
    end
  end
end
