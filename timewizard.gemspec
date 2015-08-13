# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'timewizard/version'

Gem::Specification.new do |spec|
  spec.name          = "timewizard"
  spec.version       = Timewizard::VERSION
  spec.version = "#{spec.version}-alpha-#{ENV['TRAVIS_BUILD_NUMBER']}" if ENV['TRAVIS'] && ENV['TRAVIS_BRANCH'] == 'master'
  spec.authors       = ["Richard Harrah"]
  spec.email         = ["topplethenunnery@gmail.com"]

  spec.summary       = %q{A gem for incrementing and decrementing iOS and Android app versions.}
  spec.homepage      = "https://github.com/Nunnery/timewizard"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "codeclimate-test-reporter", "~> 0.4"
end
