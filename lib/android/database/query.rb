class CouchDB
  class Query
    class AndroidQuery < Query

      def initialize(android_query)
        @android_query = android_query
      end

      def execute
        result = @android_query.run
        CouchDB::Enumerator::Android.new result
      end

    end
  end
end
