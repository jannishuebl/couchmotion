module CouchDB
module Manager
  class IOSManager

    def open(database_name)
      IOSCouchDB.new(database_name)
    end
  end
end
end
