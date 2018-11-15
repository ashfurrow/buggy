require 'slack-buggybot/issue-finder'
require 'slack-buggybot/database'
require 'slack-buggybot/models/event'
require 'slack-buggybot/models/bug'

module SlackBuggybot
  module Commands
    class Start < SlackRubyBot::Commands::Base
      command 'start'

      def self.call(client, data, match)
        url = match['expression']
        user = client.users[data[:user]]

        # Don't let people run more than one event at once.
        current_events = Event.where(owner: user.id)
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
          SlackBuggybot::Database.database.transaction do
            event = Event.new(start: Time.now.utc, owner: user.id)
            event.save
            issues.each do |url|
              Bug.new(event_id: event.id, url: url).save
            end
          end
        end
      rescue StandardError => e
        client.say(channel: data.channel, text: "Sorry, an oop happened: #{e.message}.")
      end
    end
  end
end
