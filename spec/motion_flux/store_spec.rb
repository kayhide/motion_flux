require 'spec_helper'

describe MotionFlux::Store do
  class SomeAction < MotionFlux::Action; end
  class SomeStore < MotionFlux::Store; end

  before do
    SomeStore.class_eval do
      @attributes = nil
      @instance = nil
    end
  end

  describe '.subscribe' do
    it 'calls MotionFlex::Dispatcher.register' do
      expect(MotionFlux::Dispatcher)
        .to receive(:register).with(SomeStore.instance, SomeAction)
      SomeStore.subscribe SomeAction
    end
  end

  describe '.wait_for' do
    class FirstStore < MotionFlux::Store; end
    class SecondStore < MotionFlux::Store; end

    it 'calls MotionFlex::Dispatcher.add_dependency' do
      stores = [FirstStore.instance, SecondStore.instance]
      expect(MotionFlux::Dispatcher)
        .to receive(:add_dependency).with(SomeStore.instance, stores)
      SomeStore.wait_for FirstStore, SecondStore
    end
  end

  describe '.store_attribute' do
    it 'adds attr reader' do
      SomeStore.store_attribute :city

      SomeStore.instance.instance_eval do
        @city = 'Tokyo'
      end
      expect(SomeStore.city).to eq 'Tokyo'
    end

    it 'works with many attrs' do
      SomeStore.store_attribute :city, :weather, :temperature

      SomeStore.instance.instance_eval do
        @city = 'Tokyo'
        @weather = 'Sunny'
        @temperature = '25C'
      end
      expect(SomeStore.city).to eq 'Tokyo'
      expect(SomeStore.weather).to eq 'Sunny'
      expect(SomeStore.temperature).to eq '25C'
    end
  end

  describe '.attributes' do
    it 'returns attributes' do
      SomeStore.store_attribute :city, :weather, :temperature
      expect(SomeStore.attributes).to eq %i(city weather temperature)
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
