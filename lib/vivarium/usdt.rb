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

      def __message_id_table
        @__message_id_table ||= {}
      end
      private :__message_id_table

      def __file_id_table
        @__file_id_table ||= {}
      end
      private :__file_id_table

      def get_method_name(u64)
        __method_id_table[u64]
      end

      def get_error_name(u64)
        __error_id_table[u64]
      end

      def get_message_name(u64)
        __message_id_table[u64]
      end

      def get_file_name(u64)
        __file_id_table[u64]
      end

      def register_or_resolve_method(method_signature)
        id = __helper_get_hash_from_name(method_signature)
        __method_id_table[id] ||= method_signature
        id
      end

      def register_or_resolve_error(error_name)
        id = __helper_get_hash_from_name(error_name)
        __error_id_table[id] ||= error_name
        id
      end

      def register_or_resolve_message(message)
        id = __helper_get_hash_from_name(message)
        __message_id_table[id] ||= message
        id
      end

      def register_or_resolve_file(file_name)
        id = __helper_get_hash_from_name(file_name)
        __file_id_table[id] ||= file_name
        id
      end

      def start(defined_class, method_name, file: nil, lineno: -1)
        method_signature = "#{defined_class}##{method_name}"
        method_id = register_or_resolve_method(method_signature)
        file_id = file ? register_or_resolve_file(file) : -1
        ::VivariumUsdt.invoke_start_probe(method_id, file_id, lineno)
      end

      def stop(defined_class, method_name, file: nil, lineno: -1)
        method_signature = "#{defined_class}##{method_name}"
        method_id = register_or_resolve_method(method_signature)
        file_id = file ? register_or_resolve_file(file) : -1
        ::VivariumUsdt.invoke_stop_probe(method_id, file_id, lineno)
      end

      def raise(error_name, message, file: nil, lineno: -1)
        error_id = register_or_resolve_error(error_name)
        message_id = register_or_resolve_message(message)
        file_id = file ? register_or_resolve_file(file) : -1
        ::VivariumUsdt.invoke_raise_probe(error_id, message_id, file_id, lineno)
      end
    end
  end
end
