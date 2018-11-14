require 'slack-buggybot/issue-finder'
require 'slack-buggybot/database'

module SlackBuggybot
  module Commands
    class Start < SlackRubyBot::Commands::Base
      command 'start'

      def self.call(client, data, match)
        url = match['expression']
        user = client.users[data[:user]]

        # Don't let people run more than one event at once.
        current_events = database[:events].where(owner: user.id)
        if current_events.count > 0
          client.say(channel: data.channel, text: "You already have an event in progress.")
          return
        end

        # Not sure why but the expression is surrounded by angle brackets
        url.gsub!(/[\>\<]/, "")

        issues = SlackBuggybot::IssueFinder.find(url)
        if issues.empty?
          client.say(channel: data.channel, text: "Couldn't find any issues at #{url}")
        else
          client.say(channel: data.channel, text: "Starting hackathon for #{user.real_name} with #{issues.length} issues!")
          database.transaction do
            event_id = database[:events].insert(start: Time.now.utc, owner: user.id)
            issues.each do |url|
              database[:bugs].insert(event_id: event_id, url: url)
            end
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
