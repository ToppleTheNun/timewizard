require 'test_helper'

class PackageTest < Minitest::Test
  def test_array
    assert_equal 10, Array.new(10).size
  end
end