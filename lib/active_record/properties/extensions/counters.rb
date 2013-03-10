# Allows fetching properties as numerical values by adding _count suffix

module ActiveRecord
  module Properties
    module Extensions
      module Counters
        def method_missing(*args, &block)
          method_name = args.first.to_s

          defined, result = if method_name.ends_with?('_bump!')
                              define_property_method(method_name, '_bump!') do |property_name, object|
                                _properties = object.properties
                                _properties[property_name] = object.send("#{property_name}_count") + 1
                                object.update_column(:properties, ActiveRecord::Coders::Hstore.new({}).dump(_properties))
                                _properties[property_name]
                              end
                            else
                              define_property_method(method_name, '_count') do |property_name, object|
                                object.send("#{property_name}_property").to_i
                              end
                            end

          defined ? result : super
        end
      end
    end
  end
end