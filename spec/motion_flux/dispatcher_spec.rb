require 'spec_helper'

describe MotionFlux::Dispatcher do
  class SomeAction < MotionFlux::Action; end
  class AnotherAction < MotionFlux::Action; end

  describe '.dispatch' do
    before do
      @store = double
      MotionFlux::Dispatcher.register @store, SomeAction
    end

    after do
      MotionFlux::Dispatcher.clear
    end

    it 'calls store method' do
      expect(@store).to receive(:something)
      MotionFlux::Dispatcher.dispatch SomeAction.new(:something)
    end

    it 'skips if store does not respond' do
      expect {
        MotionFlux::Dispatcher.dispatch SomeAction.new(:something)
      }.not_to raise_error
    end

    it 'skips if action is not registered' do
      expect(@store).not_to receive(:something)
      MotionFlux::Dispatcher.dispatch AnotherAction.new(:something)
    end
  end

  describe '.exclusive_run' do
    it 'calls given block' do
      obj = double
      expect(obj).to receive(:something)
      MotionFlux::Dispatcher.exclusive_run 'first' do
        obj.something
      end
    end

    it 'skips second block' do
      obj = double
      expect(obj).to receive(:something)
      expect(obj).not_to receive(:other_thing)
      MotionFlux::Dispatcher.exclusive_run 'first' do
        obj.something
        MotionFlux::Dispatcher.exclusive_run 'second' do
          obj.other_thing
        end
      end
    end
  end
end
