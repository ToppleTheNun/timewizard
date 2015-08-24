# coding: utf-8

Gem::Specification.new do |gem|
  gem.name = 'timewizard'
  lib_dir = File.join(File.dirname(__FILE__), 'lib')
  $LOAD_PATH << lib_dir unless $LOAD_PATH.include?(lib_dir)
  require 'timewizard/version'
  gem.version = Timewizard::VERSION
  if ENV.fetch('TRAVIS_BRANCH', 'development') != 'master'
    gem.version = "#{gem.version}-alpha-#{ENV['TRAVIS_BUILD_NUMBER']}"
  end

  gem.summary = 'A Ruby library for parsing and changing iOS and Android version numbers.'
  gem.description = 'Uses the RubyGems style of versioning in order to ease updates.'
  gem.licenses = ['MIT']
  gem.authors = ['Richard Harrah']
  gem.email = 'topplethenunnery@gmail.com'
  gem.homepage = 'https://nunnery.github.io/timewizard'

  glob = lambda { |patterns| gem.files & Dir[*patterns] }

  gem.files = `git ls-files`.split($/)

  gem.test_files = glob['{spec/{**/}*_spec.rb']
  gem.extra_rdoc_files = glob['*.{txt,rdoc}']

  gem.add_dependency 'versionomy', '~> 0.4'
  gem.add_dependency 'CFPropertyList', '~> 2.3'

  gem.add_development_dependency 'bundler', '~> 1.10'
  gem.add_development_dependency 'rake', '~> 10.0'
  gem.add_development_dependency 'rspec', '~> 3.3'
  gem.add_development_dependency 'yard', '~> 0.8'
  gem.add_development_dependency 'codeclimate-test-reporter', '~> 0.4'
  gem.add_development_dependency 'abide', '0.0.3'
end