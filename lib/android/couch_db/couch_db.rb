class CouchDB

  def self.init_database(database_name, context)
    CouchDB.implementation = AndroidCouchDB.new database_name, context
    true
  end

end