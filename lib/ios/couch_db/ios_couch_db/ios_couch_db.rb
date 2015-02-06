class CouchDB
  class IOSCouchDB
    def initialize(database_name)
      @database_name = database_name
    end

    def create_document
      document = database.createDocument
      CouchDB::Document::IOSDocument.new document
    end

    def document_with(id)
      document = database.documentWithID id
      CouchDB::Document::IOSDocument.new document
    end

    def view_by(name)
      view = database.viewNamed name

      CouchDB::View::IOSView.new view
    end

    def close
      database.getManager.close
    end

    def destroy
      error_ptr = Pointer.new(:object)
      database.deleteDatabase error_ptr
    end

    def database
      return @database if @database
      manager = CBLManager.sharedInstance
      error_ptr = Pointer.new(:object)
      @database = manager.databaseNamed(@database_name, error: error_ptr)
      unless @database
        error = error_ptr[0]
        raise CouldNotOpenDatabase, "error code: #{error}"
      else
        @database
      end
    end
  end
end


