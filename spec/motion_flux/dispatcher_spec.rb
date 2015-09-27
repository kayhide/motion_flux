require 'spec_helper'

describe MotionFlux::Dispatcher do
  class SomeAction < MotionFlux::Action; end
  class AnotherAction < MotionFlux::Action; end

  describe '.dispatch' do
    before do
      @store = double 'store'
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

    describe 'with dependency' do
      before do
        @first, @second = [double('first'), double('second')].each do |store|
          MotionFlux::Dispatcher.register store, SomeAction
        end
        @last = @store
        MotionFlux::Dispatcher.add_dependency @last, @second
        MotionFlux::Dispatcher.add_dependency @second, @first
      end

      it 'calls store method in order of dependencies' do
        stores = []
        [@last, @first, @second].each do |s|
          expect(s).to receive(:something) { stores << s }
        end
        MotionFlux::Dispatcher.dispatch SomeAction.new(:something)
        expect(stores).to eq [@first, @second, @last]
      end

      it 'fails when cyclic dependency detected' do
        MotionFlux::Dispatcher.add_dependency @first, @last
        expect {
          MotionFlux::Dispatcher.dispatch SomeAction.new(:something)
        }.to raise_error(TSort::Cyclic)
      end
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
