module MotionFlux
  class Store
    def emit event
      self.class.emit event
    end

    module ClassMethods
      def subscribe action
        MotionFlux::Dispatcher.register instance, action
      end

      def store_attribute *attrs
        attrs.each do |attr|
          attributes << attr

          attr_reader attr
          define_singleton_method attr do
            instance.send attr
          end
        end
      end

      def attributes
        @attributes ||= []
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
