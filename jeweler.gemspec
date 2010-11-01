# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "jeweler/version"

Gem::Specification.new do |s|
  s.name        = "jeweler"
  s.version     = Jeweler::Version::STRING
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Josh Nichols"]
  s.email       = %q{josh@technicalpickles.com}
  s.homepage    = %q{http://github.com/technicalpickles/jeweler}
  s.summary     = %q{Opinionated tool for creating and managing RubyGem projects}
  s.description = %q{Simple and opinionated helper for creating Rubygem projects on GitHub}

  s.extra_rdoc_files = [
    "ChangeLog.markdown",
    "LICENSE.txt",
    "README.markdown"
  ]

  s.add_runtime_dependency(%q<rake>, [">= 0"])
  s.add_runtime_dependency(%q<git>, [">= 1.2.5"])
  s.add_runtime_dependency(%q<bundler>, ["~> 1.0.0"])
  s.add_runtime_dependency(%q<thor>, ["~> 0.14.0"])
  s.add_development_dependency(%q<shoulda>, [">= 0"])
#  s.add_development_dependency(%q<mhennemeyer-output_catcher>, [">= 0"])
  s.add_development_dependency(%q<rr>, [">= 0"])
  s.add_development_dependency(%q<mocha>, [">= 0"])
#  s.add_development_dependency(%q<redgreen>, [">= 0"])
  s.add_development_dependency(%q<test-construct>, [">= 0"])
  s.add_development_dependency(%q<yard>, ["~> 0.6.0"])
  s.add_development_dependency(%q<bluecloth>, [">= 0"])
  s.add_development_dependency(%q<cucumber>, [">= 0"])
  s.add_development_dependency(%q<rcov>, [">= 0"])
  s.add_development_dependency(%q<timecop>, [">= 0"])
  s.add_development_dependency(%q<activesupport>, ["~> 2.3.5"])
#  s.add_development_dependency(%q<ruby-debug>, [">= 0"])

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
