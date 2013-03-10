module ActiveRecord
  module Properties
    class StringProperty < Base
      def formtastic_options
        {:as => :string}
      end
    end
  end
end
