# frozen_string_literal: true

$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'slack-buggybot'
require 'web'

%w(SLACK_API_TOKEN GITHUB_ACCESS_TOKEN DATABASE_URL JIRA_EMAIL JIRA_TOKEN).each do |e|
  raise "You need the #{e} environment variable defined." if ENV[e].nil?
end

Thread.new do
  SlackBuggybot::Bot.run
rescue Exception => e
  STDERR.puts "ERROR: #{e}"
  STDERR.puts e.backtrace
  raise e
end

run SlackBuggybot::Web
