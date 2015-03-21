module CouchDB
  module Manager
    class DoubleManager
      def open(database_name)
        DoubleCouchDB.new
      end
    end
  end
end
