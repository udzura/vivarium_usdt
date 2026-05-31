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

  test "raise stores error and message names" do
    error_name = "RuntimeError"
    message = "boom"

    Vivarium::Usdt.raise(error_name, message)

    error_id = __helper_get_hash_from_name(error_name)
    message_id = __helper_get_hash_from_name(message)

    assert_equal(error_name, Vivarium::Usdt.get_error_name(error_id))
    assert_equal(message, Vivarium::Usdt.get_message_name(message_id))
  end
end
