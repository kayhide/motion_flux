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
      MotionFlux::Dispatcher.dispatch self
    end
  end
end
