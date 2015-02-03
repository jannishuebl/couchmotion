
# Usage
## Android

For test purposes you can use the android app in the repository. (./android-test-app)

Run tests with:

```
rake spec:device files=android_couch_db_spec
rake spec:device files=init_android_couchdb_spec
```

Runnig rake spec alone will lead to mistake.


### Setup Rubymotion

You must add some *.so files and other libs to the *.apk file. Therefor we must modify RubyMotion to add this files:

```shell
      cp ./RubyMotion/0001-add-suport-for-packing-raw-files-to-apk.patch /Library/RubyMotion/
      cd /Library/RubyMotion
      git apply --check 0001-add-suport-for-packing-raw-files-to-apk.patch
If Everything is ok:
      git apply 0001-add-suport-for-packing-raw-files-to-apk.patch
```

### Add Gem to Project

Add the dependence to the Gemfile of your Android project

```ruby
gem 'couchmotion', :path => 'path/to/gem/root/', :group => :development
```

In the MainActivity init couchdb with:

```ruby
CouchDB.init_database 'Databasename', self.getApplicationContext
```

## Development

## Goals

First goal is to build a uniform API for Android and IOS therefor all Direct API calls are Wrapped. 
The Wrapper must ensure that the interface of the Android couchdb and IOS couchdb are uniform.

After this is reached couchmotion wants to give the possibility to store OpenStructs and fetch them again.
So that it can be used as the database layer of a rubymotion application plattform independent.

Example:

```ruby
class Item < CouchDBObject
end

item = Item.new
item.name = 'MyFantasticName'
item.price = 1.34

id = item.save

item = Item.find_by(id)

```

### Projectstructure

For testing the Android Api there is a test project in /android-test-app and there will be one for IOS in /ios-test-app.
All tests for the Wrappers around the nativ couchdb api should be placed in /android-test-app/spec or /ios-test-app/spec.

All other tests that are not accessing the nativ api and are using the wrappers around it should be taken to /spec folder.
A Mock Wrapper will be added for testing purposes.


