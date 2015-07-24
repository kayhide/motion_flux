require 'spec_helper'

describe MotionFlux::Action do
  class SomeAction < MotionFlux::Action; end

  describe '#to_s' do
    before do
      @action = SomeAction.new(:sometiong, 'arg')
    end

    it 'returns string' do
      expect(@action.to_s).to eq 'SomeAction:sometiong'
    end
  end

  describe '#dispatch' do
    before do
      @action = SomeAction.new(:sometiong, 'arg')
    end

    it 'calls MotionFlex::Dispatcher.dispatch' do
      expect(MotionFlux::Dispatcher).to receive(:dispatch).with(@action)
      @action.dispatch
    end
  end
end
