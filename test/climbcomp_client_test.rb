require "test_helper"

class ClimbcompClientTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::ClimbcompClient::VERSION
  end
end