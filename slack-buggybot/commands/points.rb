# frozen_string_literal: true

require 'slack-buggybot/models/event'
require 'slack-buggybot/models/bug'

module SlackBuggybot
  module Commands
    class Points < SlackRubyBot::Commands::Base
      def self.call(client, data, match)
        user = client.users[data[:user]]

        event = Event.user_current_event(user_id: user.id)
        if event.nil?
          client.say(channel: data.channel, text: "You're not in any event. Join one with `buggy join`.")
          return
        end
        
        points = Bug.user_finished_bugs(user_id: user.id, event_id: event.id).count
        client.say(channel: data.channel, text: "You have #{points} #{points == 1 ? 'point' : 'points'} in #{event.name_from_client(client)}.")
      rescue StandardError => e
        client.say(channel: data.channel, text: "Sorry, an oop happened: #{e.message}.")
      end
    end
  end
end
