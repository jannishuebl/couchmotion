class CouldNotOpenDatabase < StandardError

  def initialize(exception)
    @exception = exception
  end

end
