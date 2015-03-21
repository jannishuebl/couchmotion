class CouchDB
  class AndroidCouchDB
    def initialize(database)
      @database = database
    end

    def create_document
      document = database.createDocument
      CouchDB::Document::AndroidDocument.new document
    end

    def document_with(id)
      document = database.getDocument id
      CouchDB::Document::AndroidDocument.new document
    end

    def view_by(name)
      view = database.getView name

      CouchDB::View::AndroidView.new view
    end

    def destroy
      database.delete
    end

    def database
        @database
    end
  end
end


