module Jeweler
  class Generator
    module TestingFrameworks
      class Rspec < Base
        def initialize(generator)
          super
          use_inline_templates! __FILE__
          rakefile_snippets << lookup_inline_template(:rakefile_snippet)
          development_dependencies << ["rspec", "~> 2.0.0"]
        end

        def run
          super

          template 'rspec/.rspec', '.rspec'
        end

        def default_rake_task
          'spec'
        end

        def feature_support_require
          'rspec/expectations'
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
      end # class Rspec
    end # module TestingFrameworks
  end # class Generator
end # module Jeweler
__END__
@@ rakefile_snippet
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.rspec_opts = %w(--color)
  spec.ruby_opts  = %w(-w)
end

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.rcov = true
end
