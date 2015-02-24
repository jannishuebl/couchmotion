describe 'CouchDB' do

  behaves_like 'CouchDB'

  def open_manager
    CouchDB.open_manager
  end

  def manager_class
    CouchDB::Manager::IOSManager
  end

  def open_database(database_name)
    CouchDB.open database_name
  end

  def database_class
    CouchDB::IOSCouchDB
  end
end