require 'spec_helper'

describe MotionFlux::Store do
  class SomeAction < MotionFlux::Action; end

  class SomeStore < MotionFlux::Store; end

  describe '.subscribe' do
    it 'calls MotionFlex::Dispatcher.register' do
      expect(MotionFlux::Dispatcher)
        .to receive(:register).with(SomeStore.instance, SomeAction)
      SomeStore.subscribe SomeAction
    end
  end

  describe '.on' do
    it 'appends handler' do
      expect {
        SomeStore.on :event do
          true
        end
      }.to change(SomeStore.handlers, :count).by(1)
    end
  end

  describe '.emit' do
    it 'calls handler' do
      handler = double
      expect(handler).to receive(:call)
      SomeStore.handlers[:event] << handler
      SomeStore.emit :event
    end
  end

  describe '#emit' do
    before do
      @store = SomeStore.instance
    end

    it 'calls MotionFlex::Store.emit' do
      expect(SomeStore).to receive(:emit).with(:event)
      @store.emit :event
    end
  end
end
