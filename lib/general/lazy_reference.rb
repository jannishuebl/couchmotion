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
  def initialize(objs)
    @objs = objs
  end

  def real_object
    object_list = []
    @objs.each do |obj_hash|
      obj = Object.const_get(obj_hash[:type]).fetch_by_id obj_hash[:id]
      object_list << obj
    end
    object_list
  end
end
