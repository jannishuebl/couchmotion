module CouchDB

  module ClassMethods

    attr_accessor :manager, :databases
    def open_manager
      @manager = Manager::DoubleManager.new
      true
    end

    def open(database_name)
      database = CouchDB::Database.new(database_name, DoubleCouchDB.new)
      @databases ||= Hash.new
      @databases[database_name] = database
      @default ||= database

      create_views
      true
    end
  end

  extend ClassMethods
end
