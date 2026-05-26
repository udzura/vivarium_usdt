# frozen_string_literal: true

require "test_helper"

class VivariumUsdtTest < Test::Unit::TestCase
  test "VERSION" do
    assert do
      ::Vivarium::Usdt.const_defined?(:VERSION)
    end
  end

  test "put and get method name" do
    method_signature = "SomeClass#some_method"
    method_id = Vivarium::Usdt.register_or_resolve_method(method_signature)
    assert_equal(method_signature, Vivarium::Usdt.get_method_name(method_id))
  end
end
