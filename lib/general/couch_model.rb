motion_require 'couch_db/couch_db_impl'
motion_require 'utils/couchstruct'

class CouchModel < CouchStruct

  def self.view_for_type(view_name, options)

    class_type = self.name
    class_type = options[:type].name if options[:type]

    map = Proc.new do |document, emitter|
      type = document.property_for(:model_type)

      if type && type == class_type
        options[:map].call document, emitter
      end
    end

    reduce = options[:reduce]
    version = options[:version]


    CouchDB.add_view[view_name] = {map: map, reduce: reduce, version: version}
  end

  def self.inherited(subclass)
    view_for_type :"all_for_#{subclass.name}", map: Proc.new { |doc, emitter| emitter.emit doc.property_for(:model_type), nil }, type: subclass
  end


  def self.all
    query = CouchDB.view_by(:"all_for_#{self.name}").create_query
    query.with_key self.name
    enumerator = query.execute
    enumerator.map do |key, document|
      self.new document.properties
    end
  end

  def self.fetch_by_view_and_keys(view, keys)
    query = CouchDB.view_by(view).create_query
    query.with_keys keys
    enumerator = query.execute
    enumerator.map do |key, document|
      self.new document.properties
    end
  end

  def self.fetch_by_id(id)
    doc = CouchDB.document_with(id)
    return self.new doc.properties
  end


  def save
    if persisted?
      document = update_document
    else
      document = create_document
    end
    self.class.new document.properties
  end

  def save!
    if persisted?
      document = update_document
    else
      document = create_document
    end
    self.marshal_load document.properties
  end

  def create_document
    document = CouchDB.create_document
    self.model_type = self.class.name

    document.put self.to_db_hash
    document
  end

  def update_document
    document = CouchDB.document_with(self._id)
    self.model_type = self.class.name
    document.put self.to_db_hash
    document
  end

  def refresh
    return self.class.new CouchDB.document_with(_id).properties if persisted?
    self.new table
  end

  def refresh!
    return self.marshal_load CouchDB.document_with(_id).properties if persisted?
    self
  end

  def persisted?
    if _id && _rev
      return true
    end
    false
  end

  def delete
    CouchDB.document_with(_id).delete
  end

end

# class TestCouchModel2 < CouchModel
#
#   collection :member
#
# end
