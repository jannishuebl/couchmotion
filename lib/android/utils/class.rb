class Should
  def kind_of?(clazz)
    self.kind_of? clazz
  end
end
class DBClass

  def initialize(clazz)
    @clazz = clazz
  end

  def name
    @clazz.getName
  end
end
