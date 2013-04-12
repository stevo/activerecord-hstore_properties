module ActiveRecord
  module Properties
    module CommonAccessors
      extend ActiveSupport::Concern
      included do
        add_property_accessor '_property' do |property|
          properties[property.name.to_s]
        end

        add_property_accessor '=' do |property, *args|
          properties_will_change!
          properties[property.name] = args.shift
        end
      end
    end
  end
end