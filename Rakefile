require 'bundler'
Bundler::GemHelper.install_tasks

require 'cucumber/rake/task'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts  = "features --format pretty"
end

task :default => :spec
