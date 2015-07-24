module MotionFlux
  class Dispatcher
    module ClassMethods
      def subscribers
        @subscribers ||= Hash.new { |hash, key| hash[key] = [] }
      end

      def register store, action
        puts "#{store} is registered on #{action}"
        subscribers[action] << store
      end

      def clear
        subscribers.clear
      end

      def dispatch action
        exclusive_run action do
          subscribers[action.class].each do |store|
            if store.respond_to? action.message
              store.send action.message, action
            else
              puts "#{store}##{action.message} is not defined."
            end
          end
        end
      end

      def exclusive_run action, &proc
        if @current_action
          puts 'cascading action dispatch is not allowed.'
          puts "#{@current_action} is on process."
        else
          @current_action = action
          begin
            proc.call
          ensure
            @current_action = nil
          end
        end
      end
    end

    extend ClassMethods
  end
end
