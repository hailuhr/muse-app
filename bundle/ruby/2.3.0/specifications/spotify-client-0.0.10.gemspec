# -*- encoding: utf-8 -*-
# stub: spotify-client 0.0.10 ruby lib

Gem::Specification.new do |s|
  s.name = "spotify-client".freeze
  s.version = "0.0.10"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Claudio Poli".freeze]
  s.date = "2015-10-08"
  s.description = "Ruby client for the Spotify Web API".freeze
  s.email = ["claudio@icorete.ch".freeze]
  s.homepage = "https://github.com/icoretech/spotify-client".freeze
  s.rubyforge_project = "[none]".freeze
  s.rubygems_version = "2.6.10".freeze
  s.summary = "Ruby client for the Spotify Web API".freeze

  s.installed_by_version = "2.6.10" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<excon>.freeze, ["~> 0.37"])
      s.add_development_dependency(%q<rspec>.freeze, ["~> 3.0"])
      s.add_development_dependency(%q<guard-rspec>.freeze, [">= 0"])
    else
      s.add_dependency(%q<excon>.freeze, ["~> 0.37"])
      s.add_dependency(%q<rspec>.freeze, ["~> 3.0"])
      s.add_dependency(%q<guard-rspec>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<excon>.freeze, ["~> 0.37"])
    s.add_dependency(%q<rspec>.freeze, ["~> 3.0"])
    s.add_dependency(%q<guard-rspec>.freeze, [">= 0"])
  end
end
