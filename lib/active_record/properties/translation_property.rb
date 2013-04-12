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

      I18n.available_locales.each do |locale|
        add_property_accessor "_#{locale.to_s.underscore}" do |property|
          property_name = "#{property.name.to_s}_#{locale.to_s.underscore}"
          properties[property_name]
        end

        add_property_accessor "_#{locale.to_s.underscore}=" do |property, *args|
          property_name = "#{property.name.to_s}_#{locale.to_s.underscore}"
          properties[property_name] = args.shift
        end
      end
    end
  end
end