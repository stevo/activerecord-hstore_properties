module ActiveRecord
  module Properties
    class CounterProperty < Base
      include ActiveRecord::Properties::CommonAccessors

      def formtastic_options
        {:as => :number, :disabled => true}
      end

      add_property_accessor '_count' do |property|
        properties[property.name].to_i
      end

      add_property_accessor '_bump!' do |property|
        _properties = properties
        _properties[property.name] = properties[property.name].to_i + 1
        update_column(:properties, ActiveRecord::Coders::Hstore.new({}).dump(_properties))
        _properties[property.name]
      end

    end
  end
end