require 'with_model'
require 'active_record'
require 'activerecord-postgres-hstore'
require 'pry'

#For later testing of translation properties
I18n.available_locales = [:"nb-NO", :"en-GB", :pl]

RSpec.configure do |config|
  ActiveRecord::Base.establish_connection(
      :adapter => 'sqlite3',
      :database => ':memory:'
  )

  config.extend WithModel
end