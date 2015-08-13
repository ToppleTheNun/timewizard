require 'test_helper'
require 'timewizard/utils/wizardry'

class WizardryTest < Minitest::Test

  def test_to_i_int
    stringy = '100'

    expected = 100
    actual = Timewizard::Utils::Wizardry.to_i stringy

    assert_equal expected, actual
  end

  def test_to_i_string
    stringy = 'stringy'

    expected = 0
    actual = Timewizard::Utils::Wizardry.to_i stringy

    assert_equal expected, actual
  end

  def test_only_semver
    stringy = 'version 0.0.1'

    expected = '0.0.1'
    actual = Timewizard::Utils::Wizardry.only_semver stringy

    assert_equal expected, actual
  end

end