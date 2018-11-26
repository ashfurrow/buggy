# frozen_string_literal: true

require 'slack-buggybot/models/event'
require 'slack-buggybot/models/bug'

module SlackBuggybot
  module Commands
    class Leaderboard < SlackRubyBot::Commands::Base
      def self.call(client, data, match)
        user = client.users[data[:user]]

        event = Event.user_current_event(user_id: user.id)
        # Maybe the user is asking for an event they created, but didn't join.
        event ||= Event.open.where(owner: user.id).first
        # Maybe the user specified an event with match data
        event ||= Event.find_from_match(match)
        if event.nil?
          client.say(channel: data.channel, text: "Couldn't find event to print leaderboard.")
          return
        end

        message = <<~EOS
          Leaderboard for #{event.name_from_client(client)} (#{Bug.done_in_event(event.id).count} fixed, #{Bug.remaining_in_event(event.id).count} remaining):
          #{event.leaderboard_from_client(client)}
        EOS

        client.say(channel: data.channel, text: message)
      rescue StandardError => e
        client.say(channel: data.channel, text: "Sorry, an oop happened: #{e.message}.")
        STDERR.puts e.backtrace
      end
    end
  end
end
