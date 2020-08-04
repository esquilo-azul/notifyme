# frozen_string_literal: true

RSpec.describe ::Notifyme::Utils::SuppressClassMethod do
  let(:stub_class) do
    ::Class.new do
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
  end

  let(:metodo1_result) { stub_class.new.metodo1 }
  let(:metodo2_result) { stub_class.new.metodo2 }

  it { expect(metodo1_result).to eq('original1') }
  it { expect(metodo2_result).to eq('original2') }

  context 'when methods are supressed' do
    let(:instance) do
      r = described_class.new
      r.add(stub_class, :metodo1) { outro_metodo1 }
      r.add(stub_class, :metodo2) { 'supressed2' }
      r
    end

    let(:on_supress_result) do
      instance.on_suppress do
        metodo1_result
        metodo2_result
        'result'
      end
    end

    before do
      on_supress_result
    end

    it { expect(metodo1_result).to eq('supressed1') }
    it { expect(metodo2_result).to eq('supressed2') }
    it { expect(stub_class.new.metodo1).to eq('original1') }
    it { expect(stub_class.new.metodo2).to eq('original2') }
    it { expect(on_supress_result).to eq('result') }
  end
end
