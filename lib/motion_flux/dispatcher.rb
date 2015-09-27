require 'motion_flux/dependency_graph'

module MotionFlux
  module Dispatcher
    module_function

    def subscribers
      @subscribers ||= Hash.new { |hash, key| hash[key] = [] }
    end

    def dependencies
      @dependencies ||= DependencyGraph.new
    end

    def register store, action
      subscribers[action] << store
    end

    def add_dependency store, depended_stores
      @order = nil
      dependencies[store] ||= []
      dependencies[store].concat Array.wrap(depended_stores)
    end

    def clear
      subscribers.clear
      dependencies.clear
    end

    def dispatch action
      exclusive_run action do
        ordered_subscribers(action).each do |store|
          if store.respond_to? action.message
            store.send action.message, action
          else
            puts "#{store}##{action.message} is not defined."
          end
        end
      end
    end

    def ordered_subscribers action
      @order ||= dependencies.tsort.each_with_index.to_h
      subscribers[action.class].sort_by { |x| @order[x] || @order.length }
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
end
