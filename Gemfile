# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

gem 'slack-ruby-bot'
gem 'celluloid-io'

gem 'puma'
gem 'sinatra'
gem "octokit", "~> 4.0"

gem 'pg'
gem 'sequel'

group :development, :test do
  gem 'rake', '~> 10.4'
  gem 'rubocop', '0.31.0'
  gem 'foreman'
  gem 'guard', require: false
  gem 'guard-rspec', require: false
end

group :test do
  gem 'rspec'
  gem 'rspec-mocks'
  gem 'rack-test'
  gem 'vcr'
  gem 'webmock'
end
