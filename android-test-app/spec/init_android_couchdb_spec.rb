describe 'CouchDB' do

  it 'should create a Android CouchDB implementation' do


    result = CouchDB.init_database 'test-db', self.main_activity.getApplicationContext

    result.should == true
    CouchDB.instance_internal.couchdb.class.inspect.should == 'AndroidCouchDB'

    CouchDB.instance_internal.couchdb.destroy
  end

end