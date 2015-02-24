module CouchDB
  class Enumerator
    class DoubleEnumerator

      def initialize(rows, reduce_value)
        @rows = rows
        @reduce_value = reduce_value
      end

      def reduce_value
        @reduce_value
      end

      def map(&block)
        @rows.map do | row |
          key = row[:key]
          document = row[:document]
          block.call(key, document)
        end
      end

    end
  end
end
