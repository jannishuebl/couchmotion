class DBClass

  def initialize(clazz)
    @clazz = clazz
  end

  def name
    @clazz.getName
  end
end
