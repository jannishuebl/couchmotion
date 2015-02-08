class CouchDB
  class Document
    class DoubleDocument

    def initialize id
      @properties = {_id: id} 
    end

    def put(new_properties)
      @properties.merge! new_properties
      property_for(:_id)
    end

    def property_for(key)
      properties[key]
    end

    def properties
      @properties
    end

    end
  end
end
