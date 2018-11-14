require 'slack-buggybot/issue-finders/github'

module SlackBuggybot
  class IssueFinder
    def self.find(url)
      case url
      when /github\.com\/(?<repo>[^\/]+\/[^\/]+)\/issues\?q=(?<query>[^$]*)/
        IssueFinders::GitHub.find($~[:repo], $~[:query])
      when /github\.com\/(?<repo>[^\/]+\/[^\/]+)/
        IssueFinders::GitHub.find($~[:repo])
      else
        raise "Couldn't parse that URL: #{url}"
      end
    end
  end
end
