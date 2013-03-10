require "active_record/properties/base"
require "active_record/properties/boolean_property"
require "active_record/properties/counter_property"
require "active_record/properties/number_property"
require "active_record/properties/string_property"
require "active_record/properties/extensions/booleans"
require "active_record/properties/extensions/counters"

module ActiveRecord
  module HstoreProperties
    extend ActiveSupport::Concern

    included do
     include ActiveRecord::Properties::Extensions::Booleans
      include ActiveRecord::Properties::Extensions::Counters

      serialize :properties, ::ActiveRecord::Coders::Hstore
      class_attribute :_properties
    end

    def define_property_method(method_name, suffix, &block)
      if method_name.ends_with?(suffix) and (self.class._properties.detect { |pn| pn.name.to_s == method_name.sub(suffix, '') })
        prop_name = method_name.sub(suffix, '')
        self.class.send(:define_method, method_name) do
          block.call(prop_name, self)
        end
        [true, block.call(prop_name, self)]
      else
        [false, nil]
      end
    end

    module ClassMethods
      def properties(*args)
        if args.blank?
          self._properties ||= []
        else
          self._properties ||= []

          new_properties = extract_properties(args)
          self._properties += new_properties

          new_properties.each do |property|
            define_method("#{property.name.to_s}_property") { properties[property.name.to_s] }
          end
        end
      end

      def default_property_klass
        ActiveRecord::Properties::StringProperty
      end

      private

      def extract_properties(args)
        typed_properties = args.extract_options!

        result = args.map { |property| default_property_klass.new(property) }
        typed_properties.each do |property, _type|
          result << "active_record/properties/#{_type.to_s}_property".camelize.constantize.new(property)
        end
        result
      end
    end
  end
end