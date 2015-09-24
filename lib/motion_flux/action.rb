module MotionFlux
  class Action
    attr_reader :message, :args

    def initialize message, *args
      @message = message
      @args = args
    end

    def to_s
      "#{self.class}:#{message}"
    end

    def dispatch
      Dispatcher.dispatch self
    end

    module ClassMethods
      def dispatch message, *args
        new(message, *args).dispatch
      end
    end

    extend ClassMethods
  end
end
