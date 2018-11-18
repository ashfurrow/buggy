# frozen_string_literal: true

require 'slack-buggybot/models/event'
require 'slack-buggybot/models/bug'

module SlackBuggybot
  module Commands
    class Events < SlackRubyBot::Commands::Base
      def self.call(client, data, _match)
        if Event.open.count == 0
          client.say(channel: data.channel, text: 'There are no events right now. Start one with `buggy start`.')
          return
        end
        table = <<~EOS
          Current events:
        EOS
        Event.open.each do |e|
          owner = client.users[e.owner]
          table += "#{e.pk} | #{e.name_from_client(client)} | #{Bug.ready_in_event(e.id).count} ready bugs"
        end
        client.say(channel: data.channel, text: table)
      end
    end
  end
end
