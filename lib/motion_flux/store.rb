module MotionFlux
  class Store
    def emit event
      self.class.emit event
    end

    module ClassMethods
      def subscribe action
        MotionFlux::Dispatcher.register instance, action
      end

      def instance
        @instance ||= new
      end

      def handlers
        @handlers ||= Hash.new { |hash, key| hash[key] = [] }
      end

      def on event, &proc
        handlers[event] << proc
      end

      def emit event
        handlers[event].each(&:call)
      end
    end

    extend ClassMethods
  end
end
