class Lazy
end
class LazyReference < Lazy
  def initialize(id)
    @id = id
  end

  def real_object
    Database.instance.fetch_object_by_id(@id)
  end
end
class LazyCollection < Lazy
  def initialize(ids)
    @ids = ids
  end

  def real_object
    object_list = []
    @ids.each do |id|
      object_list << Database.instance.fetch_object_by_id(id)
    end
    object_list
  end
end
