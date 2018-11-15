require 'slack-buggybot/issue-finder'
require 'slack-buggybot/database'
require 'slack-buggybot/models/event'
require 'slack-buggybot/models/bug'

module SlackBuggybot
  module Commands
    class Start < SlackRubyBot::Commands::Base
      def self.call(client, data, match)
        channel_name, url = match['expression'].split(" ")
        user = client.users[data[:user]]

        # Channel names come through as "<CE4HP6V8A|buggy-test-channel>"
        channel_name = channel_name.gsub(/[\>\<\#]/, "").split("|").first
        channel = client.channels[channel_name]
        if channel.nil?
          client.say(channel: data.channel, text: "Couldn't find the channel #{channel_name}")
          return
        end

        # Don't let people run more than one event at once.
        current_events = Event.open.where(owner: user.id)
        if current_events.count > 0
          client.say(channel: data.channel, text: "You already have an event in progress: #{current_events.first.name_from_client(client)}.")
          return
        end

        # Not sure why but the expression is surrounded by angle brackets
        url.gsub!(/[\>\<]/, "")

        issues = SlackBuggybot::IssueFinder.find(url)
        if issues.empty?
          client.say(channel: data.channel, text: "Couldn't find any issues at #{url}")
        else
          SlackBuggybot::Database.database.transaction do
            event = Event.new(start: Time.now.utc, owner: user.id, channel_id: channel.id)
            event.save
            issues.each do |url|
              Bug.new(event_id: event.id, url: url).save
            end
          end
          message = "Started hackathon for #{user.real_name} with #{issues.length} issues!"
          client.say(channel: data.channel, text: message)
          if channel.member? client.self.id
            client.say(channel: channel.id, text: message)
          else
            client.say(channel: data.channel, text: "Please make sure that buggy is invited to ##{channel.name}.")
          end
        end
      rescue StandardError => e
        client.say(channel: data.channel, text: "Sorry, an oop happened: #{e.message}.")
      end
    end
  end
end
