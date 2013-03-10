#
#require 'active_support'
#
#if defined? Rails
#  require "activerecord-hstore_properties/railties"
#else
#  ActiveSupport.on_load :active_record do
#    require "activerecord-hstore_properties/activerecord"
#  end
#end
require "activerecord-hstore_properties/version"
require "active_record/hstore_properties"