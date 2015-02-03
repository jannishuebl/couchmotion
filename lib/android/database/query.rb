class CouchDB
  class Query
    class AndroidQuery < Query

      def initialize(android_query)
        @android_query = android_query
      end

      def execute
        result = @android_query.run
        CouchDB::Enumerator::AndroidEnumerator.new result
      end

      def keys(keys)
        @android_query.setKeys(keys)
      end

    end
  end
end
