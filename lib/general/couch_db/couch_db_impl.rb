module CouchDB

  module ClassMethods

    def manager=(manager)

    end

    def initialize
      @databases = {}
    end

    def close
      @databases = {}
      @manager = nil
      @default = nil
    end

    def with_name(database_name)
      @databases[database_name]
    end

    def database
      @default
    end
  end



  class Database

    attr_reader :couchdb_impl, :name

    def initialize(name, couchdb_impl)
      @couchdb_impl = couchdb_impl
      @name = name
    end

    def create_document
      @couchdb_impl.create_document
    end

    def document_by
      @couchdb_impl.document_by
    end

    def view_by(name)
      @couchdb_impl.view_by(name)
    end

  end

end