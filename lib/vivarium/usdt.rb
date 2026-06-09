require "vivarium_usdt/vivarium_usdt"

module Vivarium
  module Usdt
    class << self
      def start(defined_class, method_name, file: nil, lineno: -1)
        method_signature = "#{defined_class}##{method_name}"
        ::VivariumUsdt.invoke_start_probe(method_signature, file || "", lineno)
      end

      def stop(defined_class, method_name, file: nil, lineno: -1)
        method_signature = "#{defined_class}##{method_name}"
        ::VivariumUsdt.invoke_stop_probe(method_signature, file || "", lineno)
      end

      def raise(error_name, message, file: nil, lineno: -1)
        ::VivariumUsdt.invoke_raise_probe(error_name, message, file || "", lineno)
      end
    end
  end
end
