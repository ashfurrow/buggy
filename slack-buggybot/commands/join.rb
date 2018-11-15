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
          client.say(channel: data.channel, text: "You're already in #{existing_event.name_from_client(client)}. Leave it with `buggy leave`.")
          return
        end

        unless Event.open.count > 0
          client.say(channel: data.channel, text: 'There are no events right now. Start one with `buggy start`.')
          return
        end

        event = Event.find_from_match(match)
        unless event.nil?
          join(client: client, event: Event.open.first, user: user, channel: data.channel)
        else
          client.say(channel: data.channel, text: "Couldn't find an event with id #{match[:expression]}.")
          SlackBuggybot::Commands::Events.call(client, data, match)
        end
      end
      
      def self.join(client:, event:, user:, channel:)
        event.update(users: event.users + [user.id])
        client.say(channel: channel, text: "You have joined #{event.name_from_client(client)}!")
        # TODO: Assign them a bug.
      end
    end
  end
end
