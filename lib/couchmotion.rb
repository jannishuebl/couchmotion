unless defined?(Motion::Project::Config)
  raise "This file must be required within a RubyMotion project Rakefile."
end

require 'rubygems'
require 'motion-maven'

Motion::Project::App.setup do |app|


  if Motion::Project.constants.include? :IOSConfig && app.class.to_s == "Motion::Project::IOSConfig"
    config_couchmotion_for_ios app
  end
  if Motion::Project.constants.include? :AndroidConfig
    config_couchmotion_for_android app
  end
  Dir.glob(File.join(File.dirname(__FILE__), 'general/**/*.rb')).each do |file|
    app.files.unshift(file)
  end
end

def config_couchmotion_for_android(app)
  Dir.glob(File.join(File.dirname(__FILE__), 'android/**/*.rb')).each do |file|
    app.files.unshift(file)
  end

  app.maven do 
    dependency 'com.couchbase.lite', :artifact => 'couchbase-lite-android', :version => '1.0.4', :type => 'aar'
  end

  vendor_dir = File.join(File.dirname(__FILE__), '../vendor')
  libs = []
  libs << "#{vendor_dir}/native_libs/lib/armeabi/libcom_couchbase_touchdb_RevCollator.so"
  libs << "#{vendor_dir}/native_libs/lib/armeabi/libcom_couchbase_touchdb_TDCollateJSON.so"

  app.vendor_project :jar => "#{vendor_dir}/cbl_collator_so-1.0.3.1.jar", :native => libs
end

def config_couchmotion_for_ios(app)
  Dir.glob(File.join(File.dirname(__FILE__), 'ios/**/*.rb')).each do |file|
    app.files.unshift(file)
  end
end

namespace :maven do
  task :install do
    jar_root = "#{Motion::Project::Maven::MAVEN_ROOT}/target"
    `cd #{jar_root} && rm -rf unpack`
    `cd #{jar_root} && mkdir unpack`
    `cd #{jar_root} && cp dependencies.jar unpack`
    `cd #{jar_root}/unpack && unzip -o dependencies.jar`
    `cd #{jar_root}/unpack && unzip -o classes.jar`
    `cd #{jar_root}/unpack && rm -rf classes.jar`
    `cd #{jar_root}/unpack && rm -rf dependencies.jar`
    `cd #{jar_root}/unpack && jar -cf dependencies.jar *`
    `cd #{jar_root}/unpack && cp dependencies.jar ..`
    `cd #{jar_root} && rm -rf unpack`
    end
end
