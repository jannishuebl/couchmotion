class StandardError < Java::Lang::Exception

end
class NoMethodError < StandardError
  def initialize
    # TODO: args anpassen

  end

end

class NotImplementedError < StandardError
end
