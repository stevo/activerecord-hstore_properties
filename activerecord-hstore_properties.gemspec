# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'activerecord-hstore_properties/version'

Gem::Specification.new do |gem|
  gem.name          = "activerecord-hstore_properties"
  gem.version       = Activerecord::HstoreProperties::VERSION
  gem.authors       = ["stevo"]
  gem.email         = ["blazej.kosmowski@selleo.com"]
  gem.homepage      = "https://github.com/stevo/activerecord-hstore_properties"
  gem.summary       = "hStore-based model properties on steroids!"
  gem.description   = "Allows to describe field names that will be stored within hstore column together with their types. Data can then be retrieved with a set of helpful getters."

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]


  gem.add_dependency 'activesupport', '>= 3.2.12'
  gem.add_dependency 'activerecord-postgres-hstore', '>= 0.7.5'

  gem.add_development_dependency "rspec"
  gem.add_development_dependency "sqlite3"
  gem.add_development_dependency "activerecord", '>= 3.2.12'
  gem.add_development_dependency "with_model"
  gem.add_development_dependency  "with_model", "~> 0.3.1"
  gem.add_development_dependency  "pry"

end