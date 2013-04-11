module ActiveRecord
  module Properties
    class TranslationProperty < Base
      def formtastic_options
        {:as => :string}
      end

      add_property_accessor '=' do |property, *args|
        property_name = "#{property.name.to_s}_#{I18n.locale.to_s.underscore}"
        properties[property_name] = args.shift
      end

      add_property_accessor '_property' do |property|
        property_name = "#{property.name.to_s}_#{I18n.locale.to_s.underscore}"
        properties[property_name]
      end
    end
  end
end
