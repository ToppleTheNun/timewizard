#!/usr/bin/env ruby

class Object
  # Returns true if nil or empty.
  # @return [Boolean] nil or empty
  def blank?
    respond_to?(:empty?) ? empty? : !self
  end
end

if ENV['TRAVIS_TAG'].blank?
  puts 'Not running gemnasium update'
else
  puts 'Running gemnasium update'
  `gemnasium autoupdate run`
end