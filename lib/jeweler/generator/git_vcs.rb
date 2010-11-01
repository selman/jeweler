module Jeweler
  class Generator
    class GitVcs < Plugin
      def run
        git_init '.'
        add_git_remote '.', 'origin', git_remote
      end
    end # class GitVcs
  end # class Generator
end # module Jeweler
