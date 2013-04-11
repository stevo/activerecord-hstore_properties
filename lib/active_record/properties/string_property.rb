module ActiveRecord
  module Properties
    class StringProperty < Base
      include ActiveRecord::Properties::CommonAccessors

      def formtastic_options
        {:as => :string}
      end
    end
  end
end
