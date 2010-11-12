require 'thor/group'
require 'jeweler/plugin'
require 'jeweler/application'

module Jeweler
  class << self
    def git_config value
      `git config #{value}`.chomp
    end
  end

  class Generator < Thor::Group
    include Thor::Actions

    desc "e.g. jeweler the-perfect-gem"

    argument :project, :required => true, :banner => 'gem_project'

    # gem info
    class_option :user_name, :group => 'gem info', :type => :string,
    :default => Jeweler::git_config('user.name'),
    :desc =>  "the user's name, credited in the LICENSE"

    class_option :user_email, :group => 'gem info', :type => :string,
    :default => Jeweler::git_config('user.email'),
    :desc => "the user's email, ie that is credited in the Gem specification"

    class_option :homepage, :group => 'gem info', :type => :string,
    :desc => "the homepage for your project (defaults to the GitHub repo)"

    class_option :summary, :group => 'gem info', :type => :string,
    :default => 'TODO: one-line summary of your gem',
    :desc => 'one-line summary of your gem'

    class_option :description, :group => 'gem info', :type => :string,
    :default => 'TODO: longer description of your gem',
    :desc => 'longer description of your gem'

    # git info group
    class_option :github_user, :group => 'git info', :type => :string,
    :default => Jeweler::git_config('github.user'),
    :desc => "name of the user on GitHub to set the project up under"

    class_option :github_token, :group => 'git info', :type => :string,
    :default => Jeweler::git_config('github.token'),
    :desc => "GitHub token to use for interacting with the GitHub API"

    class_option :create_github_repo, :aliases => '-g', :group => 'git info', :type => :boolean,
    :default => false,
    :desc => "create the repository on GitHub"

    # bdd group
    class_option :testing, :aliases => '-t', :group => 'bdd', :type => :string,
    :banner => '[bacon|minitest|riot|rspec|rspec1|shoulda|testspec|testunit]',
    :default => 'shoulda',
    :desc => 'testing framework to generate'

    class_option :cucumber, :aliases => '-c', :group => 'bdd', :type => :boolean,
    :default => false,
    :desc => 'generate cucumber stories in addition to other tests'

    # documentation group
    class_option :documentation, :aliases => '-d', :group => 'documentation',  :type => :string,
    :banner => '[rdoc|yard]', :default => 'rdoc',
    :desc => 'documentation framework to generate'

    # code metrics group
    class_option :code_metrics, :aliases => '-m', :group => 'code metrics',  :type => :array,
    :banner => 'reek roodi',
    :desc => 'code metrics you can choose many'

    def self.source_root
      File.expand_path('../templates', __FILE__)
    end

    def check_github_options
      if options[:create_github_repo]
        unless options[:github_user] || options[:github_token]
          raise "You must configure your Github user & token"
          exit
        end
      end
    end

    def generate_args_opts
      return if options.empty?

      args = %w(default)
      opts = options.dup

      args << opts[:testing]          #if opts[:testing]
      args << opts[:documentation]    #if opts[:documentation]
      args << 'cucumber'              if opts[:cucumber]
      args.push(*opts[:code_metrics]) if opts[:code_metrics]

      opts.merge!({
                    :project_name => project,
                    :constant_name =>
                    project.split(/[-_]/).collect {|each| each.capitalize }.join
                  })

      run_plugins args, opts
    end

    def git_actions
      inside(project) do
        say "Initializing git", :red
        run "git init"

        if options[:create_github_repo]
          require 'net/http'

          Net::HTTP.post_form URI.parse('http://github.com/api/v2/yaml/repos/create'),
          'login' => options[:github_user],
          'token' => options[:github_token],
          'description' => options[:description],
          'name' => project

          run "git remote add origin git@github.com:#{options[:github_user]}/#{project}.git"
        end
      end
    end

    no_tasks do
      def template2(source, *args)
        config = args.last.is_a?(Hash) ? args.pop : {}
        destination = args.first || source

        if File.exists?(destination)
          append_file destination, source, config
        else
          create_file destination, source, config
        end
      end

      def run_plugins args, opts
        project_path = Pathname.new(project).expand_path
        plugins = Plugin::generate(args, opts)
        plugins.each do |target, template|
          #say "#{name} tasks running", :red
          template2(template, "#{project_path}/#{target.gsub(/newgem/, project)}")
        end
      end
    end

  end # class Generator
end # module Jeweler
