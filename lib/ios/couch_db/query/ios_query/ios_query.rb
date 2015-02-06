class CouchDB
  class Query
    class IOSQuery

      def initialize(android_query)
        @android_query = android_query
      end

      def execute
        result = @android_query.run
        CouchDB::Enumerator::AndroidEnumerator.new result
      end

      def with_keys(keys)
        @android_query.setKeys(ConvertBetweenMotionAndJava.to_java_array(keys))
      end

      def with_key(key)
        self.with_keys([key])
      end
    end
  end
end
