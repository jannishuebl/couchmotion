class CouchDB

  def self.open(database_name, context)
    CouchDB.implementation = AndroidCouchDB.new database_name, context
    true
  end

end