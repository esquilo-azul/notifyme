require 'test_helper'

module Notifyme
  module Utils
    class SuppressClassMethodTest < ActiveSupport::TestCase
      class Stub
        def metodo1
          'original1'
        end

        def outro_metodo1
          'supressed1'
        end

        def metodo2
          'original2'
        end
      end

      test 'supress' do
        assert_equal 'original1', Stub.new.metodo1
        assert_equal 'original2', Stub.new.metodo2
        s = ::Notifyme::Utils::SuppressClassMethod.new
        s.add(Stub, :metodo1) do
          outro_metodo1
        end
        s.add(Stub, :metodo2) do
          'supressed2'
        end
        r = s.on_suppress do
          assert_equal 'supressed1', Stub.new.metodo1
          assert_equal 'supressed2', Stub.new.metodo2
          'result'
        end
        assert_equal 'original1', Stub.new.metodo1
        assert_equal 'original2', Stub.new.metodo2
        assert_equal 'result', r
      end
    end
  end
end
