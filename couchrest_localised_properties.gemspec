# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{couchrest_localised_properties}
  s.version = File.read(File.join(File.dirname(__FILE__), 'VERSION')).strip

  s.required_rubygems_version = Gem::Requirement.new("> 1.3.5") if s.respond_to? :required_rubygems_version=
  s.authors = ["Sam Lown"]
  s.date = %q{2011-03-23}
  s.description = %q{Add support to CouchRest Model for localised properties.}
  s.email = %q{me@samlown.com}
  s.extra_rdoc_files = [
    "LICENSE",
    "README.rdoc"
  ]
  s.homepage = %q{https://github.com/samlown/couchrest_localised_properties}
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Add support to CouchRest Model for localised properties.}
  
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ["lib"]
  
  s.add_dependency("couchrest_model", "~> 1.1.0.beta")
  s.add_development_dependency(%q<rspec>, "~> 1.2.0")
end

