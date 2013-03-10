module ActiveRecord
  module Properties
      class BooleanProperty < Base
        def formtastic_options
          {:as => :boolean, :checked_value => 'true', :unchecked_value => 'false'}
        end
      end
    end
  end