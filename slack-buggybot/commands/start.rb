require 'slack-buggybot/issue-finder'

module SlackBuggybot
  module Commands
    class Start < SlackRubyBot::Commands::Base
      command 'start'

      def self.call(client, data, match)
        url = match['expression']
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
