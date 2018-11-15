require 'slack-buggybot/models/event'
require 'slack-buggybot/models/event'
require 'slack-buggybot/models/bug'

module SlackBuggybot
  module Commands
    class Join < SlackRubyBot::Commands::Base
      def self.call(client, data, match)
        user = client.users[data[:user]]

        existing_event = Event.open.all.find { |e| e.users.include? user.id }
        unless existing_event.nil?
          owner = client.users[existing_event.owner]
          client.say(channel: data.channel, text: "You're already in #{owner.real_name}'s bug bash. Leave it with `buggy leave`.")
          return
        end

        if Event.open.count == 0
          client.say(channel: data.channel, text: 'There are no events right now. Start one with `buggy start`.')
          return
        elsif Event.open.count == 1
          join(client: client, event: Event.open.first, user: user, channel: data.channel)
          return
        end

        if match[:expression].nil?
          # No bug bash index was specified, so fail.
          client.say(channel: data.channel, text: "There's more than one bug bash ongoing, please specify which one you want with `buggy join ID`.")
          SlackBuggybot::Commands::Events.call(client, data, match)
        else
          pk = match[:expression].to_i
          event = Event.open[pk]
          if event.nil?
            client.say(channel: data.channel, text: "Couldn't find an event with id #{pk}.")
            SlackBuggybot::Commands::Events.call(client, data, match)
          else
            join(client: client, event: event, user: user, channel: data.channel)
          end
          # binding.irb
        end
      end
      
      def self.join(client:, event:, user:, channel:)
        event.update(users: event.users + [user.id])
        client.say(channel: channel, text: "You have joined the event!")
        # TODO: Call next command to assign bug.
      end
    end
  end
end
