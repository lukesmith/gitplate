# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

require "gitplate/gitplate"

Gem::Specification.new do |s|
  s.name        = "gitplate"
  s.version     = Gitplate::VERSION
  s.authors     = ["Luke Smith"]
  s.email       = ["dev@lukesmith.net"]
  s.homepage    = ""
  s.summary     = "Project templates from a git repository"
  s.description = "Project templates from a git repository"

  s.rubyforge_project = "gitplate"

  s.require_paths = ["lib"]

  s.add_runtime_dependency "gli"
  s.add_runtime_dependency "rainbow"
end
