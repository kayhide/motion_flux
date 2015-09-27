module MotionFlux
  class Store
    def emit event
      self.class.emit event
    end

    module ClassMethods
      def subscribe action
        MotionFlux::Dispatcher.register instance, action
      end

      def wait_for *stores
        MotionFlux::Dispatcher.add_dependency instance, stores.map(&:instance)
      end

      def store_attribute *attrs
        options = attrs.extract_options!
        attrs.each do |attr|
          attributes << attr

          attr_reader attr
          define_singleton_method attr do
            instance.send attr
          end

          if options[:default]
            instance.instance_variable_set "@#{attr}", options[:default]
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
