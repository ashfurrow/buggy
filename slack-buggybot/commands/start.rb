require 'slack-buggybot/issue-finder'
require 'slack-buggybot/database'

module SlackBuggybot
  module Commands
    class Start < SlackRubyBot::Commands::Base
      command 'start'

      def self.call(client, data, match)
        url = match['expression']

        # Don't let people run more than one event at once.
        current_events = SlackBuggybot::Database.database[:events].where(owner: data[:user])
        if current_events.count > 0
          client.say(channel: data.channel, text: "You already have an event in progress.")
          return
        end

        # Not sure why but the expression is surrounded by angle brackets
        url.gsub!(/[\>\<]/, "")
        issues = SlackBuggybot::IssueFinder.find(url)
        user = client.users[data[:user]]
        if issues.empty?
          client.say(channel: data.channel, text: "Couldn't find any issues at #{url}")
        else
          client.say(channel: data.channel, text: "Starting hackathon for #{user.real_name} with #{issues.length} issues!")
        end
      rescue StandardError => e
        client.say(channel: data.channel, text: "Sorry, an oop happened: #{e.message}.")
      end
    end
  end
end
