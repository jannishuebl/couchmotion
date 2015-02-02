class CouchDB
  class Enumerator
    class AndroidEnumerator

      def initialize(android_enumerator)
        @android_enumerator = android_enumerator
      end

      def map(&block)
        rows = []
        for index in 0..(@android_enumerator.getCount() - 1)
          android_document = @android_enumerator.getRow(index).getDocument
          rows <<  block.call(CouchDB::Document::AndroidDocument.new android_document)
        end
        rows
      end

    end
  end
end
