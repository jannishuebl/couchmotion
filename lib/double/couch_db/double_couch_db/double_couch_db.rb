require 'securerandom'

module CouchDB
  class DoubleCouchDB

    def initialize
      @views = {} 
      @documents = {}
    end

    def documents
      @documents
    end

    def views
      @views
    end

    def create_document
      id = SecureRandom.uuid
      document = CouchDB::Document::DoubleDocument.new id, self
      documents[id] = document
      document
    end

    def document_with(id)
      doc = documents[id]
      return CouchDB::Document::DoubleDocument.new id, self unless doc
      doc
    end

    def view_by(name)
      unless views[name]
        views[name] = CouchDB::View::DoubleView.new self
      end
      views[name]
    end

    def destroy
      @views = {}
      @documents = {}
    end

    def delete_doc(_id)
      documents.delete(_id)
    end

  end
end


