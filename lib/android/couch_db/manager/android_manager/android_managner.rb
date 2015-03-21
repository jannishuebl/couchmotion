module CouchDB
  module Manager
    class AndroidManager
        def initialize(manager)
          @manager = manager
        end

        def open(database_name)
          begin
            database = @manager.getDatabase(database_name)
          rescue Exception => e
            raise CouldNotOpenDatabase.new e
          end
          AndroidCouchDB.new database
        end
    end
  end
end
