
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

```
      cp ./RubyMotion/0001-add-suport-for-packing-raw-files-to-apk.patch /Library/RubyMotion/
      cd /Library/RubyMotion
      git apply --check 0001-add-suport-for-packing-raw-files-to-apk.patch
If Everything is ok:
      git apply 0001-add-suport-for-packing-raw-files-to-apk.patch
```

### Add Gem to Project

Add the dependence to the Gemfile of your Android project

```
gem 'couchmotion', :path => 'path/to/gem/root/', :group => :development
```

In the MainActivity init couchdb with:

```
CouchDB.init_database 'Databasename', self.getApplicationContext
```
