require 'spec_helper'

fdescribe Evergreen::Sequencer do
  let(:seq) { described_class.new }

  before do
    seq.clear
  end

  shared_examples_for 'a valid sequence' do |payloads,action|
    let(:events) { mkevents(payloads) }
    let(:result) { [action, payloads] }
    it "interprets the sequence #{payloads.inspect}" do
      events[0..-2].each do |e|
        expect(seq.sequence(e)).to eq(:partial)
      end
      expect(seq.sequence(events[-1])).to eq(result)
    end
  end

  shared_examples_for 'an invalid sequence' do |payloads|
    let(:events) { mkevents(payloads) }
    it "rejects the sequence #{payloads.inspect}" do
      events.each do |e|
        expect([:partial, nil]).to include(seq.sequence(e))
      end
    end
  end

  describe 'valid sequences' do
    describe 'action blu_inc_point' do
      it_behaves_like 'a valid sequence', ['Br', 'br'], :blu_inc_point
    end

    describe 'action blu_dec_point 1' do
      it_behaves_like 'a valid sequence', ['Br', 'BR', 'br'], :blu_dec_point
    end

    describe 'action blu_dec_point 2' do
      it_behaves_like 'a valid sequence', ['Br', 'BR', 'Br', 'br'], :blu_dec_point
    end

    describe 'action red_inc_point' do
      it_behaves_like 'a valid sequence', ['bR', 'br'], :red_inc_point
    end

    describe 'action start_game' do
      it_behaves_like 'a valid sequence', ['bR', 'br'], :red_inc_point
    end
  end

  describe 'invalid sequences' do
    describe 'fake sequence 1' do
      it_behaves_like 'an invalid sequence', ['BR', 'br']
    end

    describe 'fake sequence 2' do
      it_behaves_like 'an invalid sequence', ['br']
    end

    describe 'fake sequence 3' do
      it_behaves_like 'an invalid sequence', ['br', 'br', 'br']
    end

    describe 'fake sequence 4' do
      it_behaves_like 'an invalid sequence', ['Br', 'Br', 'br']
    end
  end
end
