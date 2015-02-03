class Symbol

  def to_sym
    self
  end

  def id2name
   to_s
  end

  def to_java_string
    self.to_s.toString
  end
end