# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "<%=project_name%>/version"

Gem::Specification.new do |s|
  s.name        = "<%=project_name%>"
  s.version     = <%=project_name.capitalize%>::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["<%=user_name%>"]
  s.email       = ["<%=user_email%>"]
  s.homepage    = "<%=homepage%>"
  s.summary     = %q{<%=summary%>}
  s.description = %q{<%=description%>}

  s.rubyforge_project = "<%=project_name%>"
<% generator.development_dependencies.each do |(name, version)|%>
  s.add_development_dependency("<%=name %>", "<%=version %>")
<% end %>

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
