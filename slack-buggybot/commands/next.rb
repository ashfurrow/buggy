# frozen_string_literal: true

require 'slack-buggybot/database'
require 'slack-buggybot/models/event'
require 'slack-buggybot/models/bug'
require 'slack-buggybot/helpers'

module SlackBuggybot
  module Commands
    class Next < SlackRubyBot::Commands::Base
      command 'next'
      command 'gimme'

      def self.call(client, data, match)
        user = client.users[data[:user]]
        event = Event.user_current_event(user_id: user.id)

        # Make sure they're in an event
        if event.nil?
          client.say(channel: data.channel, text: "You're not in an event. Join one with `buggy join`.")
          return
        end

        # Parse their match.expression for the fate of their current bug
        fate = 'fixed'
        message = 'fixed'
        emoji = random_fun_emoji
        case match[:expression]
        when 'fixed'
          # Nop, it's the default
        when 'docs'
          fate = 'added_docs'
          message = 'added docs to'
        when 'verified'
          fate = 'verified'
          message = 'verified the existence of'
        when 'interlinked'
          fate = 'interlinked'
          message = 'added context to'
        when 'none'
          # Mark the bug as ready for someone else.
          fate = 'ready'
          message = 'is passing on'
          emoji = ':soon:'
        when nil
          raise 'You need to give the status of your current bug to get a new one. Type `buggy next [fixed, docs, verified, interlinked, none]`'
        else
          raise 'You need to provide a status in `[fixed, docs, verified, interlinked, none]`'
        end

        SlackBuggybot::Database.database.transaction do
          # Update their current bug
          current_bug = Bug.user_existing_bug(user_id: user.id, event_id: event.id)
          unless current_bug.nil?
            # They should always have a bug, but just in case ...
            current_bug.update(state: fate, completed: Time.now.utc)
            client.say(channel: event.channel_id, text: "#{emoji} <@#{data[:user]}> #{message} #{current_bug.url}")
          end

          # Assign them a new bug
          new_bug = Bug.ready_in_event(event.id).all.sample
          if new_bug.nil?
            client.say(channel: data.channel, text: 'There are no more bugs!')
          else
            new_bug.assign(user_id: user.id)
            congrats = if match[:expression] == 'none'
                         'No problem.'
                       else
                         [
                           'Great work!',
                           'Well done!',
                           'Nice job!',
                           'Nice, keep it up!',
                           'Sweet!',
                           'Great job!'
                         ].sample
                       end
            client.say(channel: data.channel, text: "#{congrats} Here's your next bug: #{new_bug.url}")
          end
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
