class CouchDB
  class Document
    class IOSDocument

    def initialize(ios_document)
      @ios_document = ios_document
    end

    def put(properties)
      error_ptr = Pointer.new(:object)
      result = @ios_document.putProperties properties, error: error_ptr
      unless result
        error = error_ptr[0]
        raise CouldNotAddPropertiesToDocument, "error code: #{error} for hash: #{hash}"
      end
      property_for '_id'
    end

    def property_for(key)
      @ios_document.propertyForKey key
    end

    def properties
      @ios_document.properties
    end

    end

    class CouldNotAddPropertiesToDocument < StandardError
    end

  end
end
