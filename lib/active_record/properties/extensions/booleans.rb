module ActiveRecord
  module Properties
    module Extensions
      module Booleans
        def method_missing(*args, &block)
          method_name = args.first.to_s
          defined, result = define_property_method(method_name, '_enabled?') do |property_name, object|
            ::ActiveRecord::ConnectionAdapters::Column.value_to_boolean(object.send("#{property_name}_property"))
          end
          defined ? result : super
        end
      end
    end
  end
end
