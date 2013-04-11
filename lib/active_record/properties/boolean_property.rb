module ActiveRecord
  module Properties
    class BooleanProperty < Base
      def formtastic_options
        {:as => :boolean, :checked_value => 'true', :unchecked_value => 'false'}
      end

      add_property_accessor '_enabled?', '?' do |property|
        ::ActiveRecord::ConnectionAdapters::Column.value_to_boolean(properties[property.name.to_s])
      end

      add_property_accessor '_raise!', '_enable!' do |property|
        _properties = self.properties
        _properties[property.name] = true
        update_column(:properties, ActiveRecord::Coders::Hstore.new({}).dump(_properties))
        _properties[property.name]
      end

      add_property_accessor '_lower!', '_disable!' do |property|
        _properties = self.properties
        _properties[property.name] = false
        update_column(:properties, ActiveRecord::Coders::Hstore.new({}).dump(_properties))
        _properties[property.name]
      end
    end
  end
end