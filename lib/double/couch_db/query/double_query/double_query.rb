module CouchDB
  class Query
    class DoubleQuery

      def initialize(rows, keys, values, reduce_value)
        @rows = rows
        @keys = keys
        @values = values
        @reduce_value = reduce_value
      end

      def execute
        if(@filtered_documents)
          enum = CouchDB::Enumerator::DoubleEnumerator.new @filtered_documents, @reduce_value
          @filtered_documents = nil
        else

          enum = CouchDB::Enumerator::DoubleEnumerator.new @rows, @reduce_value
        end
        enum
      end

      def with_keys(keys)
        @filtered_documents = []
        keys.each do |key|
          @rows.each do | row |
            if row[:key].eql? key
              @filtered_documents << row
            end
          end
        end

      end

      def with_key(key)
        with_keys [key]
      end
    end
  end
end
