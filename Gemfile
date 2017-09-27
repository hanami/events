source "https://rubygems.org"

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

# Specify your gem's dependencies in hanami-events.gemspec
gemspec

unless ENV['TRAVIS']
  gem 'yard', require: false
end

gem 'simplecov', require: false, group: :test
gem 'mutant-rspec'
gem 'xml-simple'
