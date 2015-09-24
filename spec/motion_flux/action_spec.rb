require 'spec_helper'

describe MotionFlux::Action do
  class SomeAction < MotionFlux::Action; end

  describe '.dispatch' do
    it 'creates and dispathces action' do
      expect_any_instance_of(SomeAction).to receive(:dispatch) { |action|
        expect(action.message).to eq :something
        expect(action.args).to eq ['arg']
      }
      SomeAction.dispatch(:something, 'arg')
    end
  end

  describe '#to_s' do
    before do
      @action = SomeAction.new(:something, 'arg')
    end

    it 'returns string' do
      expect(@action.to_s).to eq 'SomeAction:something'
    end
  end

  describe '#dispatch' do
    before do
      @action = SomeAction.new(:something, 'arg')
    end

    it 'calls MotionFlex::Dispatcher.dispatch' do
      expect(MotionFlux::Dispatcher).to receive(:dispatch).with(@action)
      @action.dispatch
    end
  end
end
