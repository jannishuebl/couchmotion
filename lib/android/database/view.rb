class CouchDB
  class View
    class AndroidView

      def initialize(android_view)
        @android_view = android_view
      end

      def select_functions(map_block, reduce_block, version)
        @android_view.setMapReduce(map_block, reduce_block, version)
      end

      def create_query
        CouchDB::Query::Android.new @android_view.createQuery
      end
    end
  end
end
