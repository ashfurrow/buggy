require 'slack-buggybot/database'
require 'slack-buggybot/models/event'

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
        case match[:expression]
        when 'fixed'
          # Nop, it's the default
        when 'docs'
          fate = 'added_docs'
        when 'verified'
          fate = 'verified'
        when 'interlinked'
          fate = 'interlinked'
        when 'none'
          # Mark the bug as ready for someone else.
          fate = 'ready'
        when nil
          raise 'You need to give the status of your current bug to get a new one. See `buggy help` for more info.'
        else
          raise 'You need to provide a status in `[fixed, docs, verified, interlinked, none]`.'
        end

        SlackBuggybot::Database.database.transaction do
          # Update their current bug
          current_bug = Bug.user_existing_bug(user_id: user.id)
          current_bug.update(state: fate)

          # Assign them a new bug
          new_bug = Bug.ready.all.sample
          if new_bug.nil?
            client.say(channel: data.channel, text: "There are no more bugs!")
          else
            new_bug.assign(user_id: user.id)
            # TODO: These messages should be more cute.
            client.say(channel: data.channel, text: "Good work! Here's your next bug: #{new_bug.url}")
          end
        end
      rescue StandardError => e
        client.say(channel: data.channel, text: "Sorry, an oop happened: #{e.message}.")
      end

      def self.database
        SlackBuggybot::Database.database
      end
    end
  end
end
