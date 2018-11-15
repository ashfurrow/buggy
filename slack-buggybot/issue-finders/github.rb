require 'octokit'
require 'cgi'

module SlackBuggybot
  module IssueFinders
    class GitHub
      def self.find(repo, query = nil)
        client = Octokit::Client.new(:access_token => ENV['GITHUB_ACCESS_TOKEN'])
        client.auto_paginate = true

        options = {}
        unless query.nil?
          options[:labels] = CGI.unescape(query)
            .split(' ')
            .select { |s| s.start_with? 'label:' }
            .map { |s| s.split(':')[1] }
            .join(',')
        end
        
        client.issues(repo, options).map { |i| i.html_url }
      end
    end
  end
end
