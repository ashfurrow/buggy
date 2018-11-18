# frozen_string_literal: true

require 'slack-buggybot/models/event'

module SlackBuggybot
  module Commands
    class Leave < SlackRubyBot::Commands::Base
      def self.call(client, data, match)
        user = client.users[data[:user]]

        existing_event = Event.user_current_event(user_id: user.id)
        if existing_event.nil?
          client.say(channel: data.channel, text: "You're not in any event. Join one with `buggy join`.")
        else
          existing_event
            .update(users: existing_event.users - [user.id])
            .save
          client.say(channel: data.channel, text: "Okay, you've left #{existing_event.name_from_client(client)}.")
          # Purposefully not announcing when people leave.
        end
      rescue StandardError => e
        client.say(channel: data.channel, text: "Sorry, an oop happened: #{e.message}.")
      end
    end
  end
end
