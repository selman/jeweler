module Jeweler
  class Generator
    class Default < Plugin

      def initialize(generator)
        super
        development_dependencies << ["jeweler", "~> 1.5.0"]
      end

      def run
        template '.gitignore'
        template 'Gemfile'
        template 'Rakefile'
        template 'LICENSE.txt'
        template 'README.rdoc'
        template '.document'
        template 'newgem.gemspec', "#{project_name}.gemspec"
        template 'lib/newgem.rb', "lib/#{project_name}.rb"
        template 'lib/newgem/version.rb', "lib/#{project_name}/version.rb"
      end
    end # Default
  end # class Generator
end # module Jewele
