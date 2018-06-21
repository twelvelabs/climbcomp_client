require 'test_helper'

class ClimbcompTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Climbcomp::VERSION
  end
end
