# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

require "gitplate/gitplate"

Gem::Specification.new do |s|
  s.name        = "gitplate"
  s.version     = Gitplate::VERSION
  s.authors     = ["Luke Smith"]
  s.email       = ["stuff@lukesmith.net"]
  s.homepage    = "http://www.gitplate.com/"
  s.platform    = Gem::Platform::RUBY
  s.summary     = "Project templates from a git repository"
  s.description = "Project templates from a git repository"

  s.rubyforge_project = "gitplate"

  s.files        = Dir["{lib}/**/*.rb", "bin/*", "LICENSE", "*.md"]
  s.require_path = 'lib'

  s.add_runtime_dependency "gli"
  s.add_runtime_dependency "rainbow"
  s.add_runtime_dependency "rubyzip"
  s.add_runtime_dependency "git"

  s.add_development_dependency 'git'
  s.add_development_dependency 'rubyzip'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rdoc'
  s.add_development_dependency 'test-unit'
  #s.add_development_dependency 'bozo'
  #s.add_development_dependency 'bozo-scripts'

  s.has_rdoc = true
  s.rdoc_options << '--title' << 'gitplate' << '--main' << 'README.rdoc' << '-ri'
  s.bindir = 'bin'
  s.executables << 'gitplate'
end
