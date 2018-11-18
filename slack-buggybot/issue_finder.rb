# frozen_string_literal: true

require 'slack-buggybot/issue-finders/github'
require 'slack-buggybot/issue-finders/jira'

module SlackBuggybot
  class IssueFinder
    def self.find(url)
      case url
      when /github\.com\/(?<repo>[^\/]+\/[^\/]+)\/issues\?q=(?<query>[^$]*)/
        IssueFinders::GitHub.find($LAST_MATCH_INFO[:repo], $LAST_MATCH_INFO[:query])
      when /github\.com\/(?<repo>[^\/]+\/[^\/]+)/
        IssueFinders::GitHub.find($LAST_MATCH_INFO[:repo])
      when /artsyproduct.atlassian.net\/[^\?]+\?jql=(?<query>[^$]*)/
        IssueFinders::Jira.find($LAST_MATCH_INFO[:query])
      else
        raise "Couldn't parse that URL: #{url}"
      end
    end
  end
end
