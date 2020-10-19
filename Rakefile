# frozen_string_literal: true

require "rake"
require "rake/testtask"
require "bundler/gem_tasks"
require "rspec/core/rake_task"

namespace :spec do
  RSpec::Core::RakeTask.new(:unit) do |task|
    file_list = FileList["spec/**/*_spec.rb"]

    task.pattern = file_list
  end

  task :coverage do
    ENV["COVERAGE"] = "true"
    Rake::Task["spec:unit"].invoke
  end

  task :mutant do
    system("mutant --include lib --require 'hanami/events' --use rspec Hanami::Events")
  end
end

task default: "spec:unit"
