# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

require "gitplate/gitplate"

Gem::Specification.new do |s|
  s.name        = "gitplate"
  s.version     = Gitplate::VERSION
  s.authors     = ["Luke Smith"]
  s.email       = ["dev@lukesmith.net"]
  s.homepage    = ""
  s.platform    = Gem::Platform::RUBY
  s.summary     = "Project templates from a git repository"
  s.description = "Project templates from a git repository"

  s.rubyforge_project = "gitplate"

  s.files = %w(
bin/gitplate
  )
  s.require_paths = ["lib"]

  s.add_runtime_dependency "gli"
  s.add_runtime_dependency "rainbow"

  s.add_development_dependency('rake')
  s.add_development_dependency('rdoc')

  s.has_rdoc = true
  s.rdoc_options << '--title' << 'gitplate' << '--main' << 'README.rdoc' << '-ri'
  s.bindir = 'bin'
  s.executables << 'gitplate'
end
