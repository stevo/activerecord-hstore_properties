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
  gem.summary       = "Facilitate defining and retrieving information from hstore column"
  gem.description   = "Allows to describe field names that will be stored within hstore column together with their types. Data can then be retrieved with a set of helpful getters."

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency "rspec"
end
