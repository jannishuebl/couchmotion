# Setup
## Android

Add to your Gemfile:

```ruby
gem 'couchmotion', :git => 'git://github.com/jannishuebl/couchmotion.git'
```

```shell
bundle install
```

Install Maven:  
Maven must be installed, for details see: https://github.com/HipByte/motion-maven

```shell
brew install maven
```

Add Maven-repository:

Add couchbase-repository to your ~/.m2/settings.xml: http://files.couchbase.com/maven2
Create the ~/.m2/settings.xml if it does not exists.

My settings.xml looks like:

```xml
<settings>
  <profiles>
    <profile>
      <id>couchmotion</id>
      <repositories>
        <repository>
          <id>couchbase</id>
          <name>the repository for couchdb</name>
          <url>http://files.couchbase.com/maven2</url>
        </repository>
      </repositories>
    </profile>
  </profiles>

  <activeProfiles>
    <activeProfile>couchmotion</activeProfile>
  </activeProfiles>
</settings>
```

Install Mavendependencies:

```shell
rake maven:install
```

Setup database by adding following lines to ```onCreate```-Method of MainActivity:

```ruby
CouchDB.init_database 'Databasename', self.getApplicationContext
```

Example:

```ruby
class MainActivity < Android::App::Activity

  def onCreate(savedInstanceState)
    super savedInstanceState
    CouchDB.init_database 'Databasename', self.getApplicationContext
    true
  end

end
```

## Usage

## Development

Testing the project:

For test purposes you can use the android app in the repository. (./android-test-app)

Run tests with:

```
rake spec
```





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


