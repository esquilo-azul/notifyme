module Notifyme
  module Utils
    # https://coderwall.com/p/t6iimq/temporarily-suppress-or-replace-a-method-on-a-ruby-object
    class SuppressClassMethod
      def initialize
        @singles = []
      end

      def add(klass, method_name, proc = nil, &block)
        @singles << SingleSuppress.new(klass, method_name, proc, &block)
      end

      def on_suppress(&block)
        on_supress_singles(@singles.dup, block)
      end

      private

      def on_supress_singles(singles, proc)
        s = singles.pop
        if s
          s.on_suppress { on_supress_singles(singles, proc) }
        else
          proc.call
        end
      end

      class SingleSuppress
        def initialize(klass, method_name, proc, &block)
          @klass = klass
          @method_name = method_name
          @proc = proc || block
        end

        def on_suppress
          original_method = @klass.instance_method(@method_name)
          begin
            define_singleton_method_by_proc(@klass, @method_name, @proc)
            yield
          ensure
            define_singleton_method_by_proc(@klass, @method_name, original_method)
          end
        end

        private

        def define_singleton_method_by_proc(klass, method_name, block)
          klass.send(:define_method, method_name, block)
        end
      end
    end
  end
end
