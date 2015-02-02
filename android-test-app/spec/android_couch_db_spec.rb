
describe 'AndroidCouchDB' do

  it 'should raise an exception when database creation fails' do
    # TODO: When Rubymotion has implemented should.raise(CouldNotOpenDatabase) use this to test if exception is thrown
    thrown = 'nothing'

    # should.raise(CouldNotOpenDatabase) do
    #   CouchDB::AndroidCouchDB.new 'test-db-name', nil
    # end

     begin
       CouchDB::AndroidCouchDB.new 'test-db-name', nil
     rescue => e
       thrown = e.class.inspect
     end
     thrown.should == 'CouldNotOpenDatabase'
  end

  it 'should create a new document' do
    database = CouchDB::AndroidCouchDB.new 'test-db', self.main_activity.getApplicationContext

    document = database.create_document
    document.class.inspect.should.kind_of CouchDB::AndroidCouchDB

    database.destroy
  end

  it 'should get a document by id' do
    database = CouchDB::AndroidCouchDB.new 'test-db', self.main_activity.getApplicationContext

    old_document = database.create_document
    old_document.put({name:123})

    id = old_document.property_for '_id'

    new_document = database.document_with id

    new_document.class.inspect.should == 'AndroidDocument'
    new_document.property_for ('name').should == 123

    database.destroy

  end


end