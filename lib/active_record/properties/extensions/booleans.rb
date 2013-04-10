module ActiveRecord
  module Properties
    module Extensions
      module Booleans
        def method_missing(*args, &block)
          method_name = args.first.to_s

            binding.pry
          defined, result = if method_name.ends_with?('_raise!', '_enable!')
                              define_property_method(method_name, '_raise!', '_enable!') do |property_name, object|
                                _properties = object.properties
                                _properties[property_name] = true
                                object.update_column(:properties, ActiveRecord::Coders::Hstore.new({}).dump(_properties))
                                _properties[property_name]
                              end
                            elsif method_name.ends_with?('_lower!', '_disable!')
                              define_property_method(method_name, '_lower!', '_disable!') do |property_name, object|
                                _properties = object.properties
                                _properties[property_name] = false
                                object.update_column(:properties, ActiveRecord::Coders::Hstore.new({}).dump(_properties))
                                _properties[property_name]
                              end
                            elsif method_name.ends_with?('_enabled?', '?')
                              define_property_method(method_name, '_enabled?', '?') do |property_name, object|
                                ::ActiveRecord::ConnectionAdapters::Column.value_to_boolean(object.send("#{property_name}_property"))
                              end
                            end

          defined ? result : super
        end
      end
    end
  end
end