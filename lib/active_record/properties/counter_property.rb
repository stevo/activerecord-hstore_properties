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
        properties_will_change!
        properties[property.name] = properties[property.name].to_i + 1
        save
        properties[property.name]
      end

    end
  end
end