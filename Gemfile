source "https://rubygems.org"

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

# Specify your gem's dependencies in hanami-events.gemspec
gemspec

gem 'yard', require: false unless ENV['TRAVIS']

gem 'simplecov', require: false, group: :test
gem 'mutant-rspec'
gem 'rubocop',   '0.50.0', require: false
