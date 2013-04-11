require 'activerecord-hstore_properties'
require 'with_model'
require 'active_record'
require 'activerecord-postgres-hstore'
require 'pry'

RSpec.configure do |config|
  ActiveRecord::Base.establish_connection(
      :adapter => 'sqlite3',
      :database => ':memory:'
  )

  config.extend WithModel
end