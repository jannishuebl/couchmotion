class ConvertBetweenMotionAndJava

  def self.to_java(value)
    if value.is_a? String
      value = value.toString
    end
    value
  end

  def self.to_motion(value)
    value = convert_java_string_to_string value
    convert_double_to_float value
  end

  def self.convert_java_string_to_string(value)
    if value.kind_of? java_string_class
      value = value.to_s
    end
    value
  end

  def self.convert_double_to_float(value)
    if value.kind_of? java_double_class
      value = value.floatValue
    end
    value
  end

  def self.java_double_class
    Java::Lang::Double
  end

  def self.java_string_class
    Java::Lang::String
  end

end