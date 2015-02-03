class CouchDB
  class View
    class AndroidView

      def initialize(android_view)
        @android_view = android_view
        @reduce = nil
      end

      def map(&block)
        @map = Mapper.new block
        save
      end

      def reduce(&block)
        @reduce = Reducer.new block
        save
      end

      def version(version)
        @version = version
        save
      end

      def save
        if @map && @version
          return @android_view.setMapReduce(@map, @reduce, @version)
        end
        false
      end

      def create_query
        CouchDB::Query::AndroidQuery.new @android_view.createQuery
      end

      class Mapper

        def initialize(block)
          @block = block
        end

        def map(document_hash, emitter)
          document = CouchDB::Document::AndroidDocument.new(FakeDocument.new(document_hash))
          @block.call(document, AndroidEmitter.new(emitter))
        end
      end

      class Reducer
        def initialize(block)
          @block = block
        end

        def reduce(keys, values, rereduce)
          keys.map! do |key|
            ConvertBetweenMotionAndJava.to_motion key
          end
          values.map! do |value|
            ConvertBetweenMotionAndJava.to_motion value
          end
          reduce_value = @block.call(keys, values, rereduce)
          ConvertBetweenMotionAndJava.to_java reduce_value
        end
      end

      class AndroidEmitter
        def initialize(emitter)
          @emitter = emitter
        end

        def emit(key, value)
          key = ConvertBetweenMotionAndJava.to_java(key)
          value = ConvertBetweenMotionAndJava.to_java(value)
          @emitter.emit(key, value)
        end
      end

      class FakeDocument
        def initialize(properties)
          @properties = properties
        end

        def putProperties(_)
          # This class is readable only
        end

        def getProperty(key)
          @properties[key]
        end

        def getProperties
          @properties
        end
      end
    end
  end
end
