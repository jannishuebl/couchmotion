shared 'Initialize CouchDB' do

  it 'should open and create a Double CouchDB implementation and close it' do

    result = open_database

    expect(result).to be true
    expect(CouchDB.instance_internal.couchdb).to be_kind_of(database_class)

    CouchDB.close
    expect(CouchDB.instance_internal.couchdb).to be nil
  end

  def open_database
    raise NotImplementedError
  end

  def database_class
    raise NotImplementedError
  end

end