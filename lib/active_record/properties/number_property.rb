module ActiveRecord
  module Properties
    class NumberProperty < Base
      def formtastic_options
        {:as => :number}
      end
    end
  end
end
