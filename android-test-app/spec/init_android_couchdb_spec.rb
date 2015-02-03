describe 'CouchDB' do

  it 'should create a Android CouchDB implementation' do


    result = CouchDB.init_database 'test-db', self.main_activity.getApplicationContext

    result.should == true
    # TODO: Change to lambda matcher (def kind_of(clazz) lambda{|obj| obj.kind_od?clazz})
    CouchDB.instance_internal.couchdb.class.inspect.should == 'AndroidCouchDB'

    CouchDB.instance_internal.couchdb.destroy
  end

end