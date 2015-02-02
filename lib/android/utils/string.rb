class String

  def chomp (pattern)
    split = self.split pattern
    split[0]
  end

  def split(pattern)
    java_split = self.toString.split(pattern)
    java_split.map { |s| s.to_s}
  end

end