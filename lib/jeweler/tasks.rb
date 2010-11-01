module Jeweler
  # Rake tasks for managing your gem.
  #
  # Here's a basic usage example:
  #
  #   Jeweler::Tasks.new do |gem|
  #     gem.name = "jeweler"
  #     gem.summary = "Simple and opinionated helper for creating RubyGem projects on GitHub"
  #     gem.email = "josh@technicalpickles.com"
  #     gem.homepage = "http://github.com/technicalpickles/jeweler"
  #     gem.description = "Simple and opinionated helper for creating RubyGem projects on GitHub"
  #     gem.authors = ["Josh Nichols"]
  #   end
  #
  # The block variable gem is actually a Gem::Specification, so you can
  # do anything you would normally do with a Gem::Specification.
  # For more details, see the official gemspec reference:
  # http://docs.rubygems.org/read/chapter/20
  #
  # In addition, it provides reasonable defaults for several values. See Jeweler::Specification for more details.

  class Tasks < Bundler::GemHelper

    alias bundler_task_install install

    def install
      bundler_task_install

      desc "Start IRB with all runtime dependencies loaded"
      task :console, [:script] do |t,args|
        # TODO move to a command
        dirs = ['ext', 'lib'].select { |dir| File.directory?(dir) }

        original_load_path = $LOAD_PATH

        cmd = if File.exist?('Gemfile')
                require 'bundler'
                Bundler.setup(:default)
              end

        # add the project code directories
        $LOAD_PATH.unshift(*dirs)

        # clear ARGV so IRB is not confused
        ARGV.clear

        require 'irb'

        # set the optional script to run
        IRB.conf[:SCRIPT] = args.script
        IRB.start

        # return the $LOAD_PATH to it's original state
        $LOAD_PATH.reject! { |path| !(original_load_path.include?(path)) }
      end
    end

  end # class Tasks
end # module Jeweler
