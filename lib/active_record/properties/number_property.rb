module ActiveRecord
  module Properties
    class NumberProperty < Base
      include ActiveRecord::Properties::CommonAccessors

      def formtastic_options
        {:as => :number}
      end
    end
  end
end
