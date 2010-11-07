# A Jeweler helps you craft the perfect Rubygem. Give him a gemspec, and he takes care of the rest.
#
# See Jeweler::Tasks for examples of how to get started. Additionally, resources are available on the wiki:
#
# * http://wiki.github.com/technicalpickles/jeweler/create-a-new-project
# * http://wiki.github.com/technicalpickles/jeweler/configure-an-existing-project
module Jeweler
  autoload :Generator, 'jeweler/generator'
  autoload :Tasks,     'jeweler/tasks'
end # module Jeweler
