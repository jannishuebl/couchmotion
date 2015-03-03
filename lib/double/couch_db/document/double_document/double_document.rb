module CouchDB
  class Document
    class DoubleDocument

    def initialize(id, database)
      @properties = {_id: id, _rev: 'rev'}
      @database = database
    end

    def put(new_properties)
      @properties.merge! Hash[new_properties.map{|(k,v)| [k.to_sym,v]}]
      property_for(:_id)
    end

    def property_for(key)
      properties[key]
    end

    def properties
      @properties
    end

      def delete
        @database.delete_doc(property_for(:_id))
        true
      end

    end
  end
end
