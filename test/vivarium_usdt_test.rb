# frozen_string_literal: true

require "test_helper"

class VivariumUsdtTest < Test::Unit::TestCase
  test "VERSION" do
    assert do
      ::Vivarium::Usdt.const_defined?(:VERSION)
    end
  end
end
