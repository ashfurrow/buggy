require 'slack-buggybot/database'
require 'slack-buggybot/models/event'

module SlackBuggybot
  module Commands
    class Next < SlackRubyBot::Commands::Base
      command 'next'
      command 'gimme'

      def self.call(client, data, match)
        user = client.users[data[:user]]

        # TODO: Find an event based on match[:expression] or just use the first one
        # TODO: find a bug and assign it. Put this in a place that can be reused by the Join command.
      end

      def self.database
        SlackBuggybot::Database.database
      end
    end
  end
end
