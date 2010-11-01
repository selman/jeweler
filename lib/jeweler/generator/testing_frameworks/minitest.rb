module Jeweler
  class Generator
    module TestingFrameworks
      class Minitest < Testunitish
        def initialize(generator)
          super

          development_dependencies << ["minitest", ">= 0"]
        end

        def default_rake_task
          'test'
        end

        def feature_support_require
          'minitest/unit'
        end

        def feature_support_extend
          'MiniTest::Assertions'
        end

        def test_dir
          'test'
        end

        def test_task
          'test'
        end

        def test_pattern
          'test/**/test_*.rb'
        end

        def test_filename
          "test_#{require_name}.rb"
        end

        def test_helper_filename
          "helper.rb"
        end
      end
    end
  end
end # module Jeweler
