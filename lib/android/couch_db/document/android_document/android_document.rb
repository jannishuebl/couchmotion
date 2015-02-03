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
        {key.to_java_string => convert_string_to_java_string(value)}
      end
    end

    def convert_string_to_java_string(value)
      if value.is_a? String
        value = value.toString
      end
      value
    end

    def property_for(key)
      string_key = key.to_java_string
      value = @android_document.getProperty string_key
      convert_from_couchdb_to_motion(value)
    end

    def convert_from_couchdb_to_motion(value)
      value = convert_java_string_to_string value
      convert_double_to_float value
    end

    def convert_java_string_to_string(value)
      if value.kind_of? java_string_class
        value = value.to_s
      end
      value
    end

    def convert_double_to_float(value)
      if value.kind_of? java_double_class
        value = value.floatValue
      end
      value
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

    def java_double_class
      Java::Lang::Double
    end

    def java_string_class
      Java::Lang::String
    end

    end
  end
end
