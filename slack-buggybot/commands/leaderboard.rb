require 'slack-buggybot/models/event'
require 'slack-buggybot/models/bug'

module SlackBuggybot
  module Commands
    class Leaderboard < SlackRubyBot::Commands::Base
      def self.call(client, data, match)
        user = client.users[data[:user]]

        event = Event.user_current_event(user_id: user.id)
        # Maybe the user is asking for an event they created, but didn't join.
        event ||= Event.open.where(owner: user.id)
        # Maybe the user specified an event with match data
        event ||= Event.find_from_match(match)
        if event.nil?
          client.say(channel: data.channel, text: "Couldn't find event to print leaderboard.")
          return
        end
        
        message = <<~EOS
        Leaderboard for #{event.name_from_client(client)} (#{Bug.ready.where(event_id: event.id).count} remaining):
        #{event.sorted_user_names_and_points_from_client(client).map { |a| "#{a[0]}: #{a[1]} point#{a[1] == 1 ? '' : 's'}" }.join("\n")}
        EOS
        
        client.say(channel: data.channel, text: message)
      rescue StandardError => e
        client.say(channel: data.channel, text: "Sorry, an oop happened: #{e.message}.")
      end
    end
  end
end
