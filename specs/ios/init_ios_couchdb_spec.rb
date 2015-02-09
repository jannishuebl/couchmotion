describe 'CouchDB' do

  behaves_like 'Initialize CouchDB'

  def open_database
    CouchDB.open 'test-db'
  end

  def database_class
    CouchDB::IOSCouchDB
  end
end