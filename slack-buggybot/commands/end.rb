require 'slack-buggybot/issue-finder'
require 'slack-buggybot/database'
require 'slack-buggybot/models/event'
require 'slack-buggybot/models/bug'

module SlackBuggybot
  module Commands
    class End < SlackRubyBot::Commands::Base
      command 'end'

      def self.call(client, data, match)
        user = client.users[data[:user]]

        current_events = Event.open.where(owner: user.id)
        if current_events.count == 0
          client.say(channel: data.channel, text: "You don't have an event in progress.")
        else
          # TODO: Print final leaderboard
          current_events.each { |e| e.update(end: Time.now.utc) }
          client.say(channel: data.channel, text: "All done!")
        end
      rescue StandardError => e
        client.say(channel: data.channel, text: "Sorry, an oop happened: #{e.message}.")
      end

      def self.database
        SlackBuggybot::Database.database
      end
    end
  end
end
