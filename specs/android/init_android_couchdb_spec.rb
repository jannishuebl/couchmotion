describe 'CouchDB' do

  def open_manager
    CouchDB.open_manager self.main_activity.getApplicationContext
  end

  def manager_class
    CouchDB::Manager::AndroidManager
  end

  def open_database(database_name)
    CouchDB.open database_name
  end

  def database_class
    CouchDB::AndroidCouchDB
  end

  behaves_like 'CouchDB'

end
