# frozen_string_literal: true

$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'web'

%w[SLACK_API_TOKEN GITHUB_ACCESS_TOKEN DATABASE_URL JIRA_EMAIL JIRA_TOKEN].each do |e|
  raise "You need the #{e} environment variable defined." if ENV[e].nil?
end

Thread.new do
  require 'slack_buggybot'
  SlackBuggybot::Bot.run
rescue StandardError => e
  STDERR.puts "ERROR: #{e}"
  STDERR.puts e.backtrace
  raise e
end

run SlackBuggybot::Web
