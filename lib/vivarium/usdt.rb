require "vivarium_usdt/vivarium_usdt"

module Vivarium
  module Usdt
    class << self
      def __method_id_table
        @__method_id_table ||= {}
      end
      private :__method_id_table
      def __error_id_table
        @__error_id_table ||= {}
      end
      private :__error_id_table

      def get_method_name(u64)
        __method_id_table[u64]
      end

      def get_error_name(u64)
        __error_id_table[u64]
      end

      def register_or_resolve_method(method_signature)
        id = __helper_get_hash_from_name(method_signature)
        __method_id_table[id] ||= method_signature
        id
      end

      def start(defined_class, method_name)
        method_signature = "#{defined_class}##{method_name}"
        method_id = register_or_resolve_method(method_signature)
        ::VivariumUsdt.invoke_start_probe(method_id)
      end

      def stop(defined_class, method_name)
        method_signature = "#{defined_class}##{method_name}"
        method_id = register_or_resolve_method(method_signature)
        ::VivariumUsdt.invoke_stop_probe(method_id)
      end

      def raise(error_name)
        error_id = __helper_get_hash_from_name(error_name)
        __error_id_table[error_id] ||= error_name
        ::VivariumUsdt.invoke_raise_probe(error_id)
      end
    end
  end
end