module Jeweler
  class Generator
    module TestingFrameworks
      class Rspec1 < Base
        def initialize(generator)
          super

          use_inline_templates! __FILE__

          rakefile_snippets << lookup_inline_template(:rakefile_snippet)
          development_dependencies << ["rspec", "~> 1.3.0"]
        end

        def run
          super

          template 'rspec1/spec.opts', 'spec/spec.opts'
        end

        def default_rake_task
          'spec'
        end

        def feature_support_require
          'spec/expectations'
        end

        def feature_support_extend
          nil # Cucumber is smart enough extend Spec::Expectations on its own
        end

        def test_dir
          'spec'
        end

        def test_task
          'spec'
        end

        def test_pattern
          'spec/**/*_spec.rb'
        end

        def test_filename
          "#{require_name}_spec.rb"
        end

        def test_helper_filename
          "spec_helper.rb"
        end
      end # class Rspec1
    end # module TestingFrameworks
  end # class Generator
end # module Jeweler
__END__
@@ rakefile_snippet
require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end
