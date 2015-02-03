class CouchDB
  class Document
    class AndroidDocument

    def initialize(android_document)
      @android_document = android_document
    end

    def put(properties)
      properties = convert_properties_to_couchdb properties
      @android_document.putProperties properties
      property_for :_id
    end

    def convert_properties_to_couchdb(properties)
      properties.hmap! do | key, value |
        {key.to_java_string => ConvertBetweenMotionAndJava.to_java(value)}
      end
    end

    def property_for(key)
      string_key = key.to_java_string
      value = @android_document.getProperty string_key
      ConvertBetweenMotionAndJava.to_motion(value)
    end


    def properties
      properties = {}
      key_array.each do | key |
        properties[key] = property_for key
      end
      properties
    end

    def key_array
      @android_document.getProperties.keySet.toArray.map do |key|
        key.to_s.to_sym
      end
    end

    end
  end
end
