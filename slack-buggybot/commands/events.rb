require 'slack-buggybot/models/event'
require 'slack-buggybot/models/event'
require 'slack-buggybot/models/bug'

module SlackBuggybot
  module Commands
    class Events < SlackRubyBot::Commands::Base
      command 'events'

      def self.call(client, data, match)
        if Event.open.count == 0
          client.say(channel: data.channel, text: 'There are no events right now. Start one with `buggy start`.')
          return
        end
        table = <<~EOS
        Current events:
        EOS
        Event.open.each do |e|
          owner = client.users[e.owner]
          table += "#{owner.real_name}'s bug bash | #{Bug.ready.where(event_id: e.id).count} ready bugs"
        end
        client.say(channel: data.channel, text: table)
      end
    end
  end
end
