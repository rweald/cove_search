# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "cove_search/version"

Gem::Specification.new do |s|
  s.name        = "cove_search"
  s.version     = CoveSearch::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Ryan Weald"]
  s.email       = ["ryan@weald.com"]
  s.homepage    = ""
  s.summary     = %q{A simple search service using redis}
  s.description = %q{A simple search service using redis ordered sets} 

  s.rubyforge_project = "cove_search"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "redis"
  s.add_dependency 'redis-namespace'
  s.add_dependency 'sinatra'
  s.add_dependency 'yajl-ruby'
  s.add_dependency 'vegas'
  s.add_dependency 'rest-client'
  s.add_development_dependency 'rack-test'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'mocha'
  s.add_development_dependency 'shotgun'
end
