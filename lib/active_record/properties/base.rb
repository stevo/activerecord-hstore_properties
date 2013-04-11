module ActiveRecord
  module Properties
    class Base < Struct.new(:name)
      class_attribute :_property_accessors

      class << self
        def property_accessors
          self._property_accessors || {}
        end

        def add_property_accessor(*suffixes, &block)
          self._property_accessors ||= {}
          self._property_accessors = _property_accessors.merge(suffixes.to_a => block)
        end
      end

      add_property_accessor '_property' do |property|
        properties[property.name.to_s]
      end

      add_property_accessor '=' do |property, *args|
        properties_will_change!
        properties[property.name.to_s] = args.shift
      end
    end
  end
end