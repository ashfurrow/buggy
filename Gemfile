# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

gem 'celluloid-io'
gem 'slack-ruby-bot'

gem 'octokit', '~> 4.0'
gem 'puma'
gem 'sinatra'

gem 'pg'
gem 'sequel'

group :development, :test do
  gem 'foreman', require: false
  gem 'guard', require: false
  gem 'guard-rspec', require: false
  gem 'pry'
  gem 'rake', '~> 10.4'
  gem 'rubocop', require: false
end

group :test do
  gem 'rack-test'
  gem 'rspec'
  gem 'rspec-mocks'
  gem 'vcr'
  gem 'webmock'
end
