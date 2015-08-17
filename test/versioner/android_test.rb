require 'test_helper'
require 'timewizard/versioner/android'

class AndroidTest < Minitest::Test

  RESOURCE_DIRECTORY = Dir.pwd.to_s + '/resources'

  attr_reader :manifest
  attr_reader :versioner

  def setup
    @versioner = Timewizard::Versioner::Android.new RESOURCE_DIRECTORY
  end

  def teardown
    # Do nothing
  end

  def test_find_manifest
    @manifest = @versioner.find_manifest

    assert !manifest.nil?
  end

  def test_open_manifest
    @manifest = @versioner.find_manifest

    # final empty string represents the newline at the end of the file
    expected_manifest_contents =
        ['<?xml version="1.0" encoding="UTF-8"?>', '',
         '<manifest xmlns:android="http://schemas.android.com/apk/res/android" package="timewizard"' +
             ' android:versionCode="200" android:versionName="0.0.1" />', ''].join("\n")
    actual_manifest_contents = @versioner.open_manifest

    assert_equal expected_manifest_contents, actual_manifest_contents
  end

  def test_find_version_code
    @manifest = @versioner.find_manifest
    manifest_contents = @versioner.open_manifest

    expected_version_code = 'android:versionCode="200"'
    actual_version_code = @versioner.find_version_code manifest_contents

    # test that returned arrays match the expected output
    assert_equal expected_version_code, actual_version_code

    # test that the calculated versions match the expected output
    assert_equal 200, @versioner.old_version_code
    assert_equal 201, @versioner.new_version_code
  end

  def test_find_version_name
    @manifest = @versioner.find_manifest
    manifest_contents = @versioner.open_manifest

    expected_version_name = 'android:versionName="0.0.1"'
    actual_version_name = @versioner.find_version_name manifest_contents

    # test that returned arrays match the expected output
    assert_equal expected_version_name, actual_version_name

    # test that the calculated versions match the expected output
    assert_equal 200, @versioner.old_version_code
    assert_equal 201, @versioner.new_version_code
  end

  def test_change_version_code_base
    @manifest = @versioner.find_manifest
    manifest_contents = @versioner.open_manifest
    base_version_code = @versioner.find_version_code manifest_contents

    # testing default behavior of change_version_code
    expected_version_code = 'android:versionCode="201"'
    actual_version_code = @versioner.change_version_code base_version_code

    assert_equal expected_version_code, actual_version_code

    assert_equal 200, @versioner.old_version_code
    assert_equal 201, @versioner.new_version_code
  end

  def test_change_version_code_arg
    @manifest = @versioner.find_manifest
    manifest_contents = @versioner.open_manifest
    base_version_code = @versioner.find_version_code manifest_contents

    # testing args-ed behavior of change_version_code
    expected_version_code = 'android:versionCode="205"'
    actual_version_code = @versioner.change_version_code base_version_code, 205

    assert_equal expected_version_code, actual_version_code

    assert_equal 200, @versioner.old_version_code
    assert_equal 205, @versioner.new_version_code
  end

  def test_change_manifest_base
    @manifest = @versioner.find_manifest
    manifest_contents = @versioner.open_manifest

    # final empty string represents the newline at the end of the file
    expected_manifest_contents =
        ['<?xml version="1.0" encoding="UTF-8"?>', '',
         '<manifest xmlns:android="http://schemas.android.com/apk/res/android" package="timewizard"' +
             ' android:versionCode="201" android:versionName="0.0.1" />', ''].join("\n")
    actual_manifest_contents = @versioner.change_manifest manifest_contents

    assert_equal expected_manifest_contents, actual_manifest_contents

    assert_equal 200, @versioner.old_version_code
    assert_equal 201, @versioner.new_version_code
  end

end