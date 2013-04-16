require 'active_support/core_ext/class'
require 'active_support/concern'
require "active_record/properties/base"
require "active_record/properties/common_accessors"
require "active_record/properties/boolean_property"
require "active_record/properties/counter_property"
require "active_record/properties/number_property"
require "active_record/properties/string_property"
require "active_record/properties/translation_property"

module ActiveRecord
  module HstoreProperties
    extend ActiveSupport::Concern

    included do
      serialize :properties, ::ActiveRecord::Coders::Hstore
      class_attribute :_properties
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
          define_accessors_for(new_properties)
        end
      end

      def default_property_klass
        ActiveRecord::Properties::StringProperty
      end

      private

      def define_accessors_for(properties)
        properties.each do |property|
          property.class.property_accessors.each do |suffixes, proc|

            method_names = suffixes.map { |suffix| "#{property.name}#{suffix}" }
            primary_method_name = method_names.shift

            #Define main method once...
            define_method(primary_method_name) do |*args|
              self.instance_exec(property, *args, &proc)
            end

            #... and then define aliases
            method_names.each do |method_name|
              unless method_defined?(method_name)
                alias_method(method_name, primary_method_name)
              end
            end
          end
        end
      end

      def extract_properties(args)
        typed_properties = args.extract_options!.stringify_keys

        result = args.map { |property| default_property_klass.new(property.to_s) }
        typed_properties.each do |property, _type|
          result << "active_record/properties/#{_type.to_s}_property".camelize.constantize.new(property)
        end
        result
      end
    end
  end
end