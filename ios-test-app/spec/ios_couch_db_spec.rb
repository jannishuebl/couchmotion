describe 'IOSCouchDB' do

  # TODO: Don't know how to bring creation it to fail
  # it 'should raise an exception when database creation fails' do
  #   TODO: When Rubymotion has implemented should.raise(CouldNotOpenDatabase) use this to test if exception is thrown
  #   thrown = 'nothing'

    # should.raise(CouldNotOpenDatabase) do
    #   CouchDB::AndroidCouchDB.new 'test-db-name', nil
    # end

     # begin
     #   CouchDB::IOSCouchDB.new 'test-db-name'
     # rescue => e
     #   thrown = e.class.inspect
     # end
     # thrown.should == 'CouldNotOpenDatabase'
  # end

  it 'should create a new document' do
    database = CouchDB::IOSCouchDB.new 'test-db'

    document = database.create_document
    # TODO: Change to lambda matcher (def kind_of(clazz) lambda{|obj| obj.kind_od?clazz})
    document.class.inspect.should == 'CouchDB::Document::IOSDocument'

    database.destroy
  end

  it 'should get a document by id' do
    database = CouchDB::IOSCouchDB.new 'test-db'

    old_document = database.create_document
    old_document.put({name:123})

    id = old_document.property_for :_id

    new_document = database.document_with id

    # TODO: Change to lambda matcher (def kind_of(clazz) lambda{|obj| obj.kind_od?clazz})
    new_document.class.inspect.should == 'CouchDB::Document::IOSDocument'
    new_document.property_for (:name).should == 123

    database.destroy
  end
end