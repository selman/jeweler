class Jeweler
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
  autoload :VersionHelper,  'jeweler/version_helper'

  class Tasks < Bundler::GemHelper

    def initialize(base, name = nil)
      super(base, name)
      @version_helper = Jeweler::VersionHelper.new(File.dirname(@spec_path))
    end

    alias bundler_task_install install

    def install
      bundler_task_install

      task :version_required do
        if jeweler.expects_version_file? && !jeweler.version_file_exists?
          abort "Expected VERSION or VERSION.yml to exist. Use 'rake version:write' to create an initial one."
        end
      end

      desc "Displays the current version"
      task :version => :version_required do
        $stdout.puts "Current version: #{@version_helper.to_s}"
      end

      # desc "Generate and validate gemspec"
      # task :gemspec => ['gemspec:generate', 'gemspec:validate']

      # namespace :gemspec do
      #   desc "Validates the gemspec on the filesystem"
      #   task :validate => :gemspec_required do
      #     jeweler.validate_gemspec
      #   end

      #   desc "Regenreate the gemspec on the filesystem"
      #   task :generate => :version_required do
      #     jeweler.write_gemspec
      #   end

      #   desc "Display the gemspec for debugging purposes, as jeweler knows it (not from the filesystem)"
      #   task :debug do
      #     # TODO move to a command
      #     jeweler.gemspec_helper.spec.version ||= begin
      #                                               jeweler.version_helper.refresh
      #                                               jeweler.version_helper.to_s
      #                                             end
          
      #     puts jeweler.gemspec_helper.to_ruby
      #   end

      #   desc "Regenerate and validate gemspec, and then commits and pushes to git"
      #   task :release do
      #     jeweler.release_gemspec
      #   end
      # end


      namespace :version do
        desc "Writes out an explicit version. Respects the following environment variables, or defaults to 0: MAJOR, MINOR, PATCH. Also recognizes BUILD, which defaults to nil"
        task :write do
          major, minor, patch, build = ENV['MAJOR'].to_i, ENV['MINOR'].to_i, ENV['PATCH'].to_i, (ENV['BUILD'] || nil )
          jeweler.write_version(major, minor, patch, build, :announce => false, :commit => false)
          $stdout.puts "Updated version: #{jeweler.version}"
        end

        namespace :bump do
          desc "Bump the major version by 1"
          task :major => [:version_required, :version] do
            jeweler.bump_major_version
            $stdout.puts "Updated version: #{jeweler.version}"
          end

          desc "Bump the a minor version by 1"
          task :minor => [:version_required, :version] do
            jeweler.bump_minor_version
            $stdout.puts "Updated version: #{jeweler.version}"
          end

          desc "Bump the patch version by 1"
          task :patch => [:version_required, :version] do
            jeweler.bump_patch_version
            $stdout.puts "Updated version: #{jeweler.version}"
          end
        end
      end

      namespace :git do
        desc "Tag and push release to git. (happens by default with `rake release`)"
        task :release do
          jeweler.release_to_git
        end
      end

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
  end
end
