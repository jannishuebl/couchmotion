
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
  def initialize(objs, parent)
    @objs = objs
    @parent = parent
  end

  def objs
    @objs
  end

  def method_missing(name, *args, &block)
    real_object.send name, *args, &block
  end

  def << (obj_to_add)
    obj_to_add.save!
    real_object << obj_to_add
    @parent.save!
  end

  def real_object
    return @object_list if @object_list
    @object_list = []
    @objs.each do |obj_hash|
      obj = Object.const_get(obj_hash[:type]).fetch_by_id obj_hash[:id]
      @object_list << obj
    end
    @object_list
  end

  def db_objects
    return @objs.map { |hash| hash.symbolize_keys} unless @object_list
    @object_list.map do |item|
      type = item.class.name
      id = item._id
      {type: type, id: id}
    end
  end
end
