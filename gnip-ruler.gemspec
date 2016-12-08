# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gnip/ruler/version'

Gem::Specification.new do |spec|
  spec.name          = "gnip-ruler"
  spec.version       = Gnip::Ruler::VERSION
  spec.authors       = ["Chirpify"]
  spec.email         = ["todd@chirpify.com"]

  spec.summary       = %q{Add, delete and list Gnip rules.}
  spec.description   = %q{The Gnip Ruler: Add, delete and list Gnip rules using Ruby.}
  spec.homepage      = "https://todgru.com"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~>1.6"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", '3.4.0'
  spec.add_development_dependency "pry"
  spec.add_runtime_dependency "rest-client"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "vcr", "~> 2.9"
end
