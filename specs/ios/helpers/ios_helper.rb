# Hack to make rubymotion testing more rspec 3.0 like
class Bacon::Context

  def expect(actual)
    @actual = actual.should
    self
  end

  def to(*args)
    @be.call
    @be = nil
    @actual = nil
    self
  end

  def not_to(*args)
    @actual = @actual.not
    to args
    self
  end

  def be_kind_of(clazz)
    @be = lambda {
      @actual.should.kind_of clazz
    }
    self
  end


  def be(expected)
    @be = lambda {
      @actual.identical_to expected
    }
    self
  end


  def eq(expected)
    @be = lambda {
      @actual.equal expected
    }
    self
  end

end