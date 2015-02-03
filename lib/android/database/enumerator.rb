class CouchDB
  class Enumerator
    class AndroidEnumerator

      def initialize(android_enumerator)
        @android_enumerator = android_enumerator
      end

      def reduce_value
        ConvertBetweenMotionAndJava.to_motion row.getValue
      end

      def map(&block)
        rows = []
        for index in 0..(@android_enumerator.getCount() - 1)
          row = @android_enumerator.getRow(index)
          document = row.getDocument
          puts "document: #{document}"
          key = ConvertBetweenMotionAndJava.to_motion row.getKey
          rows <<  block.call(key, CouchDB::Document::AndroidDocument.new(document))
        end
        rows
      end

    end
  end
end
