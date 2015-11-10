# -*- encoding: utf-8 -*-
# stub: daemonize 0.0.1 ruby lib

Gem::Specification.new do |s|
  s.name = "daemonize"
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Andrei Maxim"]
  s.date = "2011-08-11"
  s.description = "Daemon helper"
  s.email = ["andrei@seesmic.com"]
  s.homepage = "http://gems.iseesmic.com"
  s.rubyforge_project = "daemonize"
  s.rubygems_version = "2.2.2"
  s.summary = "Daemon helper"

  s.installed_by_version = "2.2.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<geminabox>, [">= 0"])
    else
      s.add_dependency(%q<geminabox>, [">= 0"])
    end
  else
    s.add_dependency(%q<geminabox>, [">= 0"])
  end
end
