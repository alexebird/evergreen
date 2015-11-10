# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "daemonize/version"

Gem::Specification.new do |s|
  s.name        = "daemonize"
  s.version     = Daemonize::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Andrei Maxim"]
  s.email       = ["andrei@seesmic.com"]
  s.homepage    = "http://gems.iseesmic.com"
  s.summary     = %q{Daemon helper}
  s.description = %q{Daemon helper}

  s.rubyforge_project = "daemonize"

  s.files         = Dir.glob("**/*").reject{ |d| File.directory?(d) }
  s.test_files    = Dir.glob("test/**/test_*.rb")

  s.require_paths = ["lib"]

  s.add_development_dependency "geminabox"
end
