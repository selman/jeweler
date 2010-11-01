require "bundler/setup"
require 'jeweler/tasks'
Jeweler::Tasks.install_tasks

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.test_files = FileList.new('test/**/test_*.rb') do |list|
    list.exclude 'test/test_helper.rb'
  end
  test.libs << 'test'
  test.verbose = true
end

namespace :test do
  task :gemspec_dup do
    gemspec = Rake.application.jeweler.gemspec
    dupped_gemspec = gemspec.dup
    cloned_gemspec = gemspec.clone
    puts gemspec.to_ruby
    puts dupped_gemspec.to_ruby
  end
end

begin
  require 'yard'
  YARD::Rake::YardocTask.new do |t|
    t.files   = FileList['lib/**/*.rb'].exclude('lib/jeweler/templates/**/*.rb')
  end
rescue LoadError
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new(:rcov => :check_dependencies) do |rcov|
    rcov.libs << 'test'
    rcov.pattern = 'test/**/test_*.rb'
  end
rescue LoadError
end

begin
  require 'cucumber/rake/task'
  Cucumber::Rake::Task.new(:features) do |features|
    features.cucumber_opts = "features --format progress"
  end
  namespace :features do
    Cucumber::Rake::Task.new(:pretty) do |features|
      features.cucumber_opts = "features --format progress"
    end
  end
rescue LoadError
end

if ENV["RUN_CODE_RUN"] == "true"
  task :default => [:test, :features]
else
  task :default => :test
end

