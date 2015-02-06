class CouchDB
  class Enumerator
    class IOSEnumerator

      def initialize(android_enumerator)
        @android_enumerator = android_enumerator
      end

      def reduce_value
        row = @android_enumerator.rowAtIndex(0)
        row.value
      end

      def map(&block)
        rows = []
        for index in 0..(@android_enumerator.count - 1)
          row = @android_enumerator.rowAtIndex(index)
          document = row.document
          key = row.key
          rows <<  block.call(key, CouchDB::Document::IOSDocument.new(document))
        end
        rows
      end

    end
  end
end
