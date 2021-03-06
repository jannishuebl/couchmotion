class CouchDB
  class Query
    class DoubleQuery

      def initialize(rows, keys, values, reduce_value)
        @rows = rows
        @keys = keys
        @values = values
        @reduce_value = reduce_value
      end

      def execute
        CouchDB::Enumerator::DoubleEnumerator.new @filtered_doucuments, @reduce_value
      end

      def with_keys(keys)
        @filtered_doucuments = []
        keys.each do |key|
          @rows.each do | row |
            if row[:key].eql? key
              @filtered_doucuments << row
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
