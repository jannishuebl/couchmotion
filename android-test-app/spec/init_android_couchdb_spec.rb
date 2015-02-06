describe 'CouchDB' do

  it 'should open and create a Android CouchDB implementation and close it' do


    result = CouchDB.open 'test-db', self.main_activity.getApplicationContext

    result.should == true
    # TODO: Change to lambda matcher (def kind_of(clazz) lambda{|obj| obj.kind_od?clazz})
    CouchDB.instance_internal.couchdb.class.inspect.should == 'AndroidCouchDB'


    CouchDB.close
    CouchDB.instance_internal.couchdb.should == nil
  end

end