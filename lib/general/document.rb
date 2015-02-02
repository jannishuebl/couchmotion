class CouchDbFacade
  class Document

    def put(properties)
      raise NotImplementedError
    end

    def property_for(key)
      raise NotImplementedError
    end

    def properties
      raise NotImplementedError
    end
  end
end