require 'test_helper'
require 'timewizard/versioner/apple'

class AppleTest < Minitest::Test

  RESOURCE_DIRECTORY = Dir.pwd.to_s + '/resources/apple/TestApp'

  attr_reader :xcodeproj
  attr_reader :plists
  attr_reader :versioner

  def setup
    @versioner = Timewizard::Versioner::Apple.new RESOURCE_DIRECTORY
  end

  def teardown
    # Do nothing
  end

  def test_find_xcodeproj
    @xcodeproj = @versioner.find_xcode_project

    assert !@xcodeproj.nil?
  end

  def test_find_plists
    @xcodeproj = @versioner.find_xcode_project
    @plists = @versioner.find_plists

    assert !@plists.nil?
    assert_equal 2, @plists.length
  end

  def test_find_build_version
    @xcodeproj = @versioner.find_xcode_project
    @plists = @versioner.find_plists

    assert_equal '1', @versioner.find_build_version(@plists)
  end

  def test_find_bundle_version
    @xcodeproj = @versioner.find_xcode_project
    @plists = @versioner.find_plists

    assert_equal '1.0', @versioner.find_bundle_version(@plists)
  end

end