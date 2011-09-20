# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "newslettre/version"

Gem::Specification.new do |s|
  s.name        = "newslettre"
  s.version     = Newslettre::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Lennart Melzer"]
  s.email       = ["l@melzer.it"]
  s.homepage    = ""
  s.summary     = %q{Sendgrid Newsletter API Client}
  s.description = %q{Create and Manage Newsletters using the Sendgrid API}

  s.rubyforge_project = "newslettre"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "httparty", "~> 0.8"

  s.add_development_dependency "rake", "~> 0.9"
  s.add_development_dependency "rspec", "~> 2"
  s.add_development_dependency "webmock", "~> 1.7"
  s.add_development_dependency "vcr", "~> 1.11"
  s.add_development_dependency "cucumber", "~> 1"
end
