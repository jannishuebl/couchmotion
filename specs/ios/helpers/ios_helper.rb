class Bacon::Context
  def expect(actual)
    @actual = actual
    self
  end

  def be_kind_of(clazz)
    @actual.should.kind_of clazz
    self
  end

  def to(*args)
    self
  end

  def be(expected)
    @actual.should == expected
    self
  end
end