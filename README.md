hstore-properties
=================

Setup
-----

Simply add following to your gemfile

`gem 'hstore-properties'`

Create `properties` column in the model you would like to use properties within, i.e.

`rails g migration AddPropertiesToUsers properties:hstore`

Apply your migration

`rake db:migrate`

Finally, describe your properties in your model file 

```ruby
class User < ActiveRecord::Base
  include ActiveRecord::HstoreProperties
  properties 'third_name', 
             'some_cool_feature' => :boolean, 
             'comments' => :counter,
             'age' => :number
end
```

Usage
-----

### Retrieving values

By default, all your properties are of type String. There are number of other property types available though...

* string
* boolean
* number
* counter
* translation

More will come in near future...

All properties can be retrieved just as they are written into hstore column, by suffixing them with `_property`, i.e.

```ruby
User.last.third_name_property #=> "Jack"
```

#### Booleans

*Boolean* properties, can be additionaly retrieved by using `_enabled?` and `?` suffixes, that will cast them to boolean value, i.e.

```ruby
User.last.some_cool_feature_enabled? #=> true
User.last.some_cool_feature? #=> true
```

What is more, you can toggle value of boolean property using `_enable!` / `_raise!` and `_disable!` / `_lower!` suffixes, e.g.

```ruby
User.last.some_cool_feature_enable! #=> Changes property to true
User.last.some_cool_feature_raise! #=> Changes property to true
User.last.some_cool_feature_disable! #=> Changes property to false
User.last.some_cool_feature_lower! #=> Changes property to false
```

#### Counters

*Counter* properties, can be retrieved by using `_count` suffix, that will cast them to integer value, i.e.

```ruby
User.last.comments_count #=> 10
```

What is more, it is possible to bump counter properties, i.e. following line will increment comments property by 1

```ruby
User.last.comments_bump!
```


### Updating through forms

You obviously need to add `:properties` to yours `attr_accessible`

Below is an example of building appropriate fields dynamically with formtastic


```erb
<%= semantic_form_for @user do |f| %>
    <%= f.first_name %>
    <%= f.fields_for :properties, OpenStruct.new(@user.properties) do |builder| %>
        <% User.properties.each do |property| %>
            <%= builder.input property.name, property.formtastic_options %>
        <% end %>
    <% end %>
    <%= f.submit %>
<% end %>
```

Further customization
---------------------

If most of your properties are of the same type, but other than string, you can overwrite `default_property_klass` to make other type default, i.e.

```ruby
class User < ActiveRecord::Base
#...
  def self.default_property_klass
    ActiveRecord::Properties::BooleanProperty
  end
end
```

When to use?
------------

* If you consider adding redundant column to your table, that will only sometimes store any data
* If you would like to make particular model "configurable"
* If you will not likely perform queries on specific field but mostly read from it directly

