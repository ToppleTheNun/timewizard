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

  def test_find_build_number
    @xcodeproj = @versioner.find_xcode_project
    @plists = @versioner.find_plists

    assert_equal '1', @versioner.find_build_number(@plists)
  end

  def test_find_bundle_version
    @xcodeproj = @versioner.find_xcode_project
    @plists = @versioner.find_plists

    assert_equal '1.0', @versioner.find_bundle_version(@plists)
  end

  def test_change_build_number_base
    @xcodeproj = @versioner.find_xcode_project
    @plists = @versioner.find_plists
    versions = @versioner.find_bundle_and_build_version @plists

    expected_versions = ['1.0', '2']
    actual_versions = @versioner.change_build_number versions

    assert_equal expected_versions[0], actual_versions[0]
    assert_equal expected_versions[1], actual_versions[1]
  end

  def test_change_build_number_args
    @xcodeproj = @versioner.find_xcode_project
    @plists = @versioner.find_plists
    versions = @versioner.find_bundle_and_build_version @plists

    expected_versions = ['1.0', '3']
    actual_versions = @versioner.change_build_number versions, '3'

    assert_equal expected_versions[0], actual_versions[0]
    assert_equal expected_versions[1], actual_versions[1]
  end

  def test_change_bundle_base
    @xcodeproj = @versioner.find_xcode_project
    @plists = @versioner.find_plists
    versions = @versioner.find_bundle_and_build_version @plists

    expected_versions = ['1', '1']
    actual_versions = @versioner.change_bundle_version versions

    assert_equal expected_versions[0], actual_versions[0]
    assert_equal expected_versions[1], actual_versions[1]
  end

  def test_change_bundle_args
    @xcodeproj = @versioner.find_xcode_project
    @plists = @versioner.find_plists
    versions = @versioner.find_bundle_and_build_version @plists

    expected_versions = ['1.1', '1']
    actual_versions = @versioner.change_bundle_version versions, '1.1'

    assert_equal expected_versions[0], actual_versions[0]
    assert_equal expected_versions[1], actual_versions[1]
  end

end