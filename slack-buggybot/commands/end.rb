# frozen_string_literal: true

require 'slack-buggybot/database'
require 'slack-buggybot/models/event'
require 'slack-buggybot/models/bug'
require 'slack-buggybot/helpers'

module SlackBuggybot
  module Commands
    class End < SlackRubyBot::Commands::Base
      def self.call(client, data, _match)
        user = client.users[data[:user]]

        event = Event.open.where(owner: user.id).first
        if event.nil?
          client.say(channel: data.channel, text: "You don't have an event in progress.")
        else
          event.update(end: Time.now.utc).save
          announcement = <<~EOS
            #{random_emojis} #{event.name_from_client(client)} is over! Here is the final leaderboard (#{Bug.done_in_event(event.id).count} fixed, #{Bug.remaining_in_event(event.id).count} unfinished):
            #{event.leaderboard_from_client(client)}
            #{random_fun_emoji} <@#{event.winning_result_from_client(client)[0].id}> is the winner :tada:
          EOS
          client.say(channel: event.channel_id, text: announcement)
          client.say(channel: data.channel, text: "All done!\n" + announcement)
        end
      rescue StandardError => e
        client.say(channel: data.channel, text: "Sorry, an oop happened: #{e.message}.")
        STDERR.puts e.backtrace
      end

      def self.database
        SlackBuggybot::Database.database
      end
    end
  end
end
