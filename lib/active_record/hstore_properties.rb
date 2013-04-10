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

    def define_property_method(method_name, *suffixes, &block)
      property_name, property_methods = evaluate_suffixes(method_name, suffixes)

      if property_name
        primary_method_name = property_methods.shift

        #Define main method once...
        self.class.send(:define_method, primary_method_name) do
          block.call(property_name, self)
        end

        #... and then define aliases
        property_methods.each { |_method_name| self.class.send(:alias_method, _method_name, primary_method_name) }

        [true, block.call(property_name, self)]
      else
        [false, nil]
      end
    end

    def evaluate_suffixes(method_name, suffixes)
      #Suffix does not match
      return [nil, []] unless method_name.ends_with?(*suffixes)

      property_name = method_name.dup
      suffixes.each{|suffix| property_name.chomp!(suffix) }

      #No property with that name
      return [nil, []] unless self.class._properties.detect{|pn| pn.name.to_s == property_name }

      [property_name, suffixes.map{|suffix| "#{property_name}#{suffix}"}]
    end


    module ClassMethods
      def properties_set(*args)
        self._properties.dup.tap do |all_properties|
          unless args.blank?
            all_properties.select! { |property| args.include?(property.name) }
          end
          all_properties.reject! { |property| property.name.to_s.starts_with?('_') }
        end
      end

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