$:.push File.expand_path(File.dirname(__FILE__))

require 'rubygems'
require 'rainbow'
require 'gli'
require 'gli_version'
require 'gitplate/gitplate'

include GLI

program_desc 'Generates a directory structure from a git repository'

version Gitplate::VERSION

desc 'Install the gitplate'
command :install do |c|
  c.action do |global_options, options, arguments|
    Gitplate.install
  end
end