class DBObject < OpenStruct

  def db_class
    DBClass.new self.class
  end

end
