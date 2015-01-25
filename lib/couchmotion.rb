unless defined?(Motion::Project::Config)
  raise "This file must be required within a RubyMotion project Rakefile."
end

Motion::Project::App.setup do |app|

  Dir.glob(File.join(File.dirname(__FILE__), 'general/**/*.rb')).each do |file|
    app.files.unshift(file)
  end

  if app.kind_of? Motion::Project::IOSConfig
    config_couchmotion_for_ios app
  end
  if app.kind_of? Motion::Project::AndroidConfig
    config_couchmotion_for_android app
  end
end

def config_couchmotion_for_android(app)
  Dir.glob(File.join(File.dirname(__FILE__), 'android/**/*.rb')).each do |file|
    app.files.unshift(file)
  end
end

def config_couchmotion_for_ios(app)
  Dir.glob(File.join(File.dirname(__FILE__), 'ios/**/*.rb')).each do |file|
    app.files.unshift(file)
  end
end
