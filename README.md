# Setup
## IOS

Still in construction

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
CouchDB.open 'Databasename', self.getApplicationContext
```

Example:

```ruby
class MainActivity < Android::App::Activity

  def onCreate(savedInstanceState)
    super savedInstanceState
    CouchDB.open 'Databasename', self.getApplicationContext
    true
  end

end
```

## Usage

### Open/Create Database

Please refer to usage guide for opening a couchdb on android and ios this is the onlything that should be different on the plattforms.

### Create a Document

```ruby
  document = CouchDB.create_document
```

### Get a Document by id
```ruby
  document = CouchDB.document_by('your-id')
```

### Working with Documents

```ruby
>>document = CouchDB.create_document
=> #<AndroidDocument:0x31d00025>
  # add properties by hash and save the Document
>>document.put({name:'value of property :name of the Document..'})
=> "effb030a-a483-40e8-bc42-bac9abfa80c8"

>>document = CouchDB.document_by("effb030a-a483-40e8-bc42-bac9abfa80c8")
  
  # get property by key (must be a Symbol)
>>id = document.property_for(:_id)
=> "effb030a-a483-40e8-bc42-bac9abfa80c8" 
>>name = document.property_for(:name)
=> "value of property :name of the Document.."

  # get a hash of all properties
>>properties_as_hash = document.properties
=> {:_id=>"effb030a-a483-40e8-bc42-bac9abfa80c8", :_rev=>"1-aa795a38d952089aea79ea82fb618d39", :name=>"value of property :name of the Document.."}
```

### Working with Views, Querys and Enumerator

#### Database contains following Documents:

```ruby
  {string: 'string1', document: 1}
  {string: 'string2', document: 2}
  {string: 'string1', document: 3}
  {string: 'string3', document: 4}
  {integer: 123, document: 5}
  {integer: 123, document: 6}
  {integer: 321, document: 7}
  {integer: 987, document: 8}
  {float: 12.3, document: 9}
  {float: 12.3, document: 10}
  {float: 3.21, document: 11}
  {float: 9.87, document: 12}
```

#### Define a View without reduce block:

```ruby
  view = CouchDB.view_by 'test-view'

  view.map do |document, emitter|

    if document.property_for(:string)
      emitter.emit document.property_for(:string), nil
    end
  end
  view.version 1
```
#### Create a Query and add searchkeys
```ruby
  view = database.view_by 'test-view'

  query = view.create_query
  
  query.with_key = 'string1'

  enumerator = query.execute
  enumerator.map do | key, document |
    # will be :
    # {string: 'string1', document: 1}
    # {string: 'string1', document: 3}
  end

  query = view.create_query
  
  query.with_keys = ['string1', 'string2']

  enumerator = query.execute
  enumerator.map do | key, document |
    # will be :
    # {string: 'string1', document: 1}
    # {string: 'string2', document: 2}
    # {string: 'string1', document: 3}
  end
```

For now you can only search for keys, start and endkey for example are not implemented yet, you are welcome to do this ;)

#### Define a View with reduce block:

```ruby
  view = database.view_by 'test-view'

  view.map do |document, emitter|

    if document.property_for(:integer)
      emitter.emit document.property_for(:integer), nil
    end
  end

  view.reduce do |keys, values, rereduce|
      # e.g. do summing up somthing
      reduce_value = 0
      keys.each { |x| reduce_value = reduce_value + x}
      reduce_value
    end
  view.version 1

  enumerator = view.create_query.execute
  # should be 1554 ;)
  puts enumerator.reduce_value
  
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

For details see https://github.com/jannishuebl/couchmotion/tree/master/android-test-app

All other tests that are not accessing the nativ api and are using the wrappers around it should be taken to /spec folder.
A Mock Wrapper will be added for testing purposes.

