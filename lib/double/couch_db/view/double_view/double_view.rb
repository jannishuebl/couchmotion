module CouchDB
  class View
    # TODO: Reduce process block
    class DoubleView

      def initialize(double_database)
        @double_database = double_database
        @reduce = nil
      end

      def map(&block)
        @map = block
        save
      end

      def reduce(&block)
        @reduce = block
        save
      end

      def version(version)
        @version = version
        save
      end

      def save
        if @map && @version
          return true
        end
        false
      end

      def create_query
        @query_documents = []
        @query_values = []
        @query_keys = []

        @double_database.documents.each do | key, document |
          @actual_document = document
          @map.call document, self
        end

        if @reduce
          reduce_value = @reduce.call @query_keys, @query_values, false
        end

        CouchDB::Query::DoubleQuery.new @query_documents, @query_keys, @query_values, reduce_value
      end

      def emit(key, value)
        @query_documents << {key: key, document: @actual_document}
        @query_values    << value
        @query_keys      << key
      end
    end
  end
end
