module ActiveRecord
  module Properties
      class CounterProperty < Base
        def formtastic_options
          {:as => :number, :disabled => true}
        end
      end
    end
  end
