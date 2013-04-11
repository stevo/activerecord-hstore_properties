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
    end
  end
end