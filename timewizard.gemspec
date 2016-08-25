# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'timewizard/version'

Gem::Specification.new do |gem|
  gem.name = 'timewizard'
  gem.version = Timewizard::VERSION

  gem.summary = 'A Ruby library for parsing and changing iOS and Android version numbers.'
  gem.description = 'Uses the RubyGems style of versioning in order to ease updates.'
  gem.licenses = ['MIT']
  gem.authors = ['Richard Harrah']
  gem.email = 'topplethenunnery@gmail.com'
  gem.homepage = 'https://nunnery.github.io/timewizard'

  glob = lambda { |patterns| gem.files & Dir[*patterns] }

  gem.files = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  gem.require_paths = ['lib']
  gem.bindir        = 'exe'
  gem.executables   = gem.files.grep(%r{^exe/}) { |f| File.basename(f) }
  gem.test_files = glob['{spec/{**/}*_spec.rb']
  gem.extra_rdoc_files = glob['*.{txt,rdoc}']

  gem.add_dependency 'CFPropertyList', '~> 2.3'
  gem.add_dependency 'nokogiri', '~> 1.6.6'
  gem.add_dependency 'versionomy', '~> 0.4'

  gem.add_development_dependency 'bundler', '~> 1.10'
  gem.add_development_dependency 'rake', '~> 10.0'
  gem.add_development_dependency 'rspec', '~> 3.3'
  gem.add_development_dependency 'yard', '~> 0.8'
  gem.add_development_dependency 'codeclimate-test-reporter', '~> 0.4'
  gem.add_development_dependency 'fuubar', '~> 2.0'
end
