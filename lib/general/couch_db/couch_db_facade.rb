class CouchDB

  def self.close
    self.instance_internal.close
  end

  def self.instance_internal
    return @instance if @instance
    @instance = CouchDB.new
  end

  def self.implementation= (implementation)
    self.instance_internal.implementation = implementation
  end

  def self.fetch_object_by_id(id)
    instance_internal.fetch_object_by_id(id)
  end

  def self.save_object(object)
    self.instance_internal.save_object object
  end

end