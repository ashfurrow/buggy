require 'slack-buggybot/issue-finder'
require 'slack-buggybot/database'
require 'slack-buggybot/models/event'
require 'slack-buggybot/models/bug'

module SlackBuggybot
  module Commands
    class End < SlackRubyBot::Commands::Base
      def self.call(client, data, match)
        user = client.users[data[:user]]

        event = Event.open.where(owner: user.id).first
        if event.nil?
          client.say(channel: data.channel, text: "You don't have an event in progress.")
        else
          event.update(end: Time.now.utc).save
          announcement = <<~EOS
            #{event.name_from_client(client)} is over! Here is the final leaderboard (#{Bug.done_in_event(event.id).count} fixed, #{Bug.remaining_in_event(event.id).count} unfinished):
            #{event.leaderboard_from_client(client)}
          EOS
          client.say(channel: event.channel_id, text: announcement)
          client.say(channel: data.channel, text: "All done!\n" + announcement)
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
