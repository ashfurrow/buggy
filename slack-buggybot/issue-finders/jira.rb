# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'json'

module SlackBuggybot
  module IssueFinders
    class Jira
      def self.find(query = nil)
        keys = []
        start_at = 0
        loop do
          uri = URI.parse("https://artsyproduct.atlassian.net/rest/api/2/search?startAt=#{start_at}&jql=#{query}")
          request = Net::HTTP::Get.new(uri)
          request.basic_auth(ENV['JIRA_EMAIL'], ENV['JIRA_TOKEN'])

          response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
            http.request(request)
          end

          raise "Error fetching from Jira (#{response.code})" unless response.is_a?(Net::HTTPSuccess)

          json = JSON.parse(response.body)

          keys += json['issues'].map { |i| i['key'] }

          total = json['total']
          page_size = json['maxResults']
          break if start_at + page_size > total

          start_at += page_size
        end

        keys.map { |k| "https://artsyproduct.atlassian.net/browse/#{k}" }
      end
    end
  end
end
