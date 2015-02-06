describe 'CouchDB' do

  it 'should open and create a Android CouchDB implementation and close it' do


    result = CouchDB.open 'test-db'

    result.should == true
    # TODO: Change to lambda matcher (def kind_of(clazz) lambda{|obj| obj.kind_od?clazz})
    CouchDB.instance_internal.couchdb.class.inspect.should == 'CouchDB::IOSCouchDB'


    CouchDB.close
    CouchDB.instance_internal.couchdb.should == nil
  end

end