module ActiveRecord
  module Properties
    class Base
      class_attribute :_property_accessors
      attr_reader :name
      def initialize(name)
        @name = name.to_s
      end

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