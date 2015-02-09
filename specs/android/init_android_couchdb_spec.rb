describe 'CouchDB' do

  def open_database
    CouchDB.open 'test-db', self.main_activity.getApplicationContext
  end

  def database_class
    CouchDB::AndroidCouchDB
  end

  behaves_like 'Initialize CouchDB'

end