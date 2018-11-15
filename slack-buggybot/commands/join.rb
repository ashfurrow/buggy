require 'slack-buggybot/models/event'
require 'slack-buggybot/models/bug'

module SlackBuggybot
  module Commands
    class Join < SlackRubyBot::Commands::Base
      def self.call(client, data, match)
        user = client.users[data[:user]]
        existing_event = Event.user_current_event(user_id: user.id)

        unless existing_event.nil?
          client.say(channel: data.channel, text: "You're already in #{existing_event.name_from_client(client)}. Leave it with `buggy leave`.")
          return
        end

        unless Event.open.count > 0
          client.say(channel: data.channel, text: 'There are no events right now. Start one with `buggy start`.')
          return
        end

        event = Event.find_from_match(match)
        unless event.nil?
          SlackBuggybot::Database.database.transaction do
            event
              .update(users: event.users + [user.id])
              .save
            event_name = event.name_from_client(client)
            client.say(channel: data.channel, text: "You have joined #{event_name}!")
            client.say(channel: event.channel_id, text: "<@#{data[:user]}> has joined #{event_name}, wish them luck!")
            new_bug = Bug.ready.all.sample
            if new_bug.nil?
              client.say(channel: data.channel, text: "There are no more bugs!")
            else
              new_bug.assign(user_id: user.id)
              client.say(channel: data.channel, text: "Welcome aboard! Here's your first bug: #{new_bug.url}")
            end
          end
        else
          client.say(channel: data.channel, text: "Couldn't find an event with id #{match[:expression]}.")
          SlackBuggybot::Commands::Events.call(client, data, match)
        end
      rescue StandardError => e
        client.say(channel: data.channel, text: "Sorry, an oop happened: #{e.message}.")
      end
    end
  end
end
