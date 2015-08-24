#!/usr/bin/env ruby

if ENV.fetch('TRAVIS_BRANCH', 'development') == 'master'
  puts 'Running gemnasium update'
  `gemnasium autoupdate run`
else
  puts 'Not running gemnasium update'
end