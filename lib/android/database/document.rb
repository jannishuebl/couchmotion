class CouchDB
  class Document
    class AndroidDocument

    def initialize(android_document)
      @android_document = android_document
    end

    def put(properties)
      properties.transform_keys! do |key|
        key.to_s.toString
      end
      properties.each do | key, value |
        if value.is_a? String
          properties[key] = value.toString
        end
      end
      @android_document.putProperties properties
      property_for '_id'
    end

    def property_for(key)
      @android_document.getProperty key
    end

    def properties
      properties = {}
      @android_document.getProperties.keySet.toArray.each do | key |
        value = @android_document.getProperty(key)
        if value.kind_of? javaStringClass
          value = value.to_s
        end
        properties[key.to_s.to_sym] = value
      end
      properties
    end

    def javaStringClass
      Class.getClass.forName('java.lang.String')
    end

    end
  end
end
