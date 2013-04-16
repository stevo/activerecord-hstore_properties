module ActiveRecord
  module Properties
    class BooleanProperty < Base
      include ActiveRecord::Properties::CommonAccessors

      def formtastic_options
        {:as => :boolean, :checked_value => 'true', :unchecked_value => 'false'}
      end

      add_property_accessor '_enabled?', '?' do |property|
        ::ActiveRecord::ConnectionAdapters::Column.value_to_boolean(properties[property.name.to_s])
      end

      add_property_accessor '_raise!', '_enable!' do |property|
        properties_will_change!
        properties[property.name] = true
        save
        properties[property.name]
      end

      add_property_accessor '_lower!', '_disable!' do |property|
        properties_will_change!
        properties[property.name] = false
        save
        properties[property.name]
      end
    end
  end
end