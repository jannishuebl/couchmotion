class CouchDB
  class Query
    class IOSQuery

      def initialize(ios_query)
        @ios_query = ios_query
      end

      def execute
        error_ptr = Pointer.new(:object)
        result = @ios_query.run error_ptr
        CouchDB::Enumerator::IOSEnumerator.new result
      end

      def with_keys(keys)
        @ios_query.keys = keys
      end

      def with_key(key)
        self.with_keys([key])
      end
    end
  end
end
