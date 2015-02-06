class CouchDB

  def self.open(database_name)
    CouchDB.implementation = IOSCouchDB.new database_name
    true
  end

end