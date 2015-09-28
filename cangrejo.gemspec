# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cangrejo/version'

Gem::Specification.new do |spec|
  spec.name          = "cangrejo"
  spec.version       = Cangrejo::VERSION
  spec.authors       = ["Ignacio Baixas"]
  spec.email         = ["ignacio@platan.us"]
  spec.summary       = %q{Crabfarm client for ruby}
  spec.description   = %q{Cangrejo lets you consume crabfarm crawlers using a simple DSL}
  spec.homepage      = "https://github.com/platanus/cangrejo-gem"
  spec.license       = "MIT"

  spec.files         = Dir['lib/**/*.rb']
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'rest-client', '~> 1.7'
  spec.add_dependency "git", "~> 1.2"
  spec.add_dependency "childprocess", "~> 0.5"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.4"
  spec.add_development_dependency "rspec", "~> 3.1"
  spec.add_development_dependency "rspec-nc", "~> 0.2"
  spec.add_development_dependency "guard", "~> 2.11"
  spec.add_development_dependency "guard-rspec", "~> 4.5"
  spec.add_development_dependency "terminal-notifier-guard", "~> 1.6", ">= 1.6.1"
  spec.add_development_dependency "sys-proctable", "~> 0.9"
end
