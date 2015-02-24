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

    def method_missing(m, *args, &block)
      @default.send(m, *args, &block)
    end

    def add_view
      @views ||= {}
    end

    def create_views
      add_view.each do | name, view |
        db_view = view_by(name)
        db_view.map &view[:map]

        if view[:reduce]
          db_view.reduce &view[:reduce]
        end
        if view[:version]
          db_view.version view[:version]
        else
          db_view.version 1
        end
      end
    end
  end

  extend ClassMethods


  class Database

    attr_reader :couchdb_impl, :name

    def initialize(name, couchdb_impl)
      @couchdb_impl = couchdb_impl
      @name = name
    end

    def create_document
      @couchdb_impl.create_document
    end

    def document_with(id)
      @couchdb_impl.document_with(id)
    end

    def view_by(name)
      @couchdb_impl.view_by(name)
    end

    def fetch_by_id(id)
      document = document_with id
      document
    end

    def destroy
      @couchdb_impl.destroy
    end

  end

end