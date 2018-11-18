# frozen_string_literal: true

module SlackBuggybot
  module Commands
    class About < SlackRubyBot::Commands::Base
      def self.call(client, data, _match)
        client.say(channel: data.channel, text: SlackBuggybot::ABOUT)
      end
    end
  end
end
