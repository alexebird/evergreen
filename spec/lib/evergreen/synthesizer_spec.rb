require 'spec_helper'

describe Evergreen::Synthesizer do
  describe '#synthesize' do
    context 'when there is an initial payload' do
      let(:syn) { described_class.new }
      let(:payloads) do
        mkpayloads %w[br]
      end

      it 'generates an event' do
        expect(syn.synthesize(payloads[0])).to be true
      end
    end

    context 'when there is an initial payload and another identical one' do
      let(:syn) { described_class.new }
      let(:payloads) do
        mkpayloads %w[br br]
      end

      it 'generates an event for the first and not the second' do
        expect(syn.synthesize(payloads[0])).to be true
        expect(syn.synthesize(payloads[1])).to be nil
      end
    end
  end
end
