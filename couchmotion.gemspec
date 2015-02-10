# -*- encoding: utf-8 -*-

require 'date'

Gem::Specification.new do |s|
  s.name        = "couchmotion"
  s.version     = "0.0.1" 
  s.date        = Date.today
  s.summary     = "Gem for integration CouchDB to Rubymotion for Android and IOS"
  s.description = "Allows to use couchbase with Ruybmotion for Android"
  s.authors     = ["Jannis Hübl"]
  s.email       = "jannis.huebl@gmail.com"
  s.homepage    = "https://github.com/jannishuebl/couchmotion"
  s.license     = "MIT"
  s.files       = Dir.glob("lib/**/*.rb").concat(Dir.glob("vendor/native_libs/**/*.so")) << "README.md" << "LICENSE" << "vendor/cbl_collator_so-1.0.3.1.jar"

# Dependencies
  s.add_dependency "motion-maven"
  s.add_dependency "motion-cocoapods"
  s.add_development_dependency "codeclimate-test-reporter"
end
