unless defined?(Motion::Project::Config)
  raise "This file must be required within a RubyMotion project Rakefile."
end

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
  vendor_dir = File.join(File.dirname(__FILE__), '../vendor')
  jars.each do |jar|
    app.vendor_project :jar => "#{vendor_dir}/#{jar}"
  end

  app.raw_file_dirs << File.join(File.dirname(__FILE__), '../vendor/raw_files')

end

def jars
  ['couchbase-lite-android-1.0.3.1.jar',
   'cbl_collator_so-1.0.3.1.jar',
   'commons-io-2.0.1.jar',
   'couchbase-lite-java-core-1.0.3.1.jar',
   'couchbase-lite-java-javascript-1.0.3.1.jar',
   'couchbase-lite-java-listener-1.0.3.1.jar',
   'jackson-core-asl-1.9.2.jar',
   'jackson-mapper-asl-1.9.2.jar',
   'rhino-1.7R3.jar',
   'td_collator_so.jar',
   'servlet-2-3.jar',
   'stateless4j-2.4.0.jar',
   'webserver-2-3.jar']
end

def config_couchmotion_for_ios(app)
  Dir.glob(File.join(File.dirname(__FILE__), 'ios/**/*.rb')).each do |file|
    app.files.unshift(file)
  end
end
