class CouchDB

  def self.close
    self.instance_internal.close
  end

  def self.create_document
    self.instance_internal.create_document
  end

  def self.document_by
    self.instance_internal.document_by
  end

  def self.view_by(name)
    self.instance_internal.view_by name
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