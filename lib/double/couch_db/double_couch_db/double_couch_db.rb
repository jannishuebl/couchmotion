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
      document = CouchDB::Document::DoubleDocument.new id
      documents[id] = document
      document
    end

    def document_with(id)
      documents[id]
    end

    def view_by(name)
      unless views[name]
        views[name] = CouchDB::View::DoubleView.new self
      end
      views[name]
    end

    def destroy
    end

  end
end


