class CouchDB
  class View
    class IOSView

      def initialize(ios_view)
        @ios_view = ios_view
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
          map = Proc.new do |document, emitter|
            @map.call CouchDB::Document::IOSDocument.new(FakeDocument.new(document)), IOSEmitter.new(emitter)

          end
          return @ios_view.setMapBlock(map, reduceBlock: @reduce, version: @version)
        end
        false
      end

      def create_query
        CouchDB::Query::IOSQuery.new @ios_view.createQuery
      end

      class IOSEmitter
        def initialize(emitter)
          @emitter = emitter
        end

        def emit(key, value)
          @emitter.call(key, value)
        end
      end
      class FakeDocument
        def initialize(properties)
          @properties = properties
        end

        def putProperties(_)
          # This class is readable only
        end

        def propertyForKey(key)
          @properties[key]
        end

        def properties
          @properties
        end
      end

    end
  end
end
