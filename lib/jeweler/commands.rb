class Jeweler
  module Commands
    module Version
      autoload :Base,      'jeweler/commands/version/base'
      autoload :BumpMajor, 'jeweler/commands/version/bump_major'
      autoload :BumpMinor, 'jeweler/commands/version/bump_minor'
      autoload :BumpPatch, 'jeweler/commands/version/bump_patch'
      autoload :Write,     'jeweler/commands/version/write'
    end
  end
end
