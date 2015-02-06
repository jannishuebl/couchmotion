class CouchDB

  def implementation=(couchdb)
    @couchdb = couchdb
  end

  def close
    couchdb.close
    @couchdb = nil
  end

  # @param [DBView] view
  def addView(view)
    db_view = couchdb.view_by view.class.name
    db_view.select_functions(view.map, view.reduce, view.version)
  end


  def save_object(object)
    hash = object.to_h
    hash = replace_references_and_lists hash
    hash[:$typ] = object.db_class.name
    save_hash hash
  end

  def replace_references_and_lists(properties_of_object_hash)

    properties_of_object_hash.each do |key, value|
      attribute_hash = nil
      attribute_hash = replace_references value, attribute_hash
      attribute_hash = replace_list value, attribute_hash
      if attribute_hash
        properties_of_object_hash[key] = attribute_hash
      end
    end
    properties_of_object_hash
  end

  def replace_list(property_value, attribute_hash)
    if property_value.kind_of? Array
      ids = []
      property_value.each do |reference_object|
        ids << save_object(reference_object)
      end
      attribute_hash = {:$typ => 'col', :_ids => ids}
    end
    attribute_hash
  end

  def replace_references(value, attribute_hash)
    if value.kind_of? DBObject
      attribute_hash = save_object_and_create_hash(value)
    end
    attribute_hash
  end

  def save_object_and_create_hash(value)
    id = save_object value
    attribute_hash = {}
    attribute_hash[:$typ] = 'ref'
    attribute_hash[:_id] = id
    attribute_hash
  end

  def object_list_for_object_class(object)
    enumerator = enumerator_for_view_name object.name
    enumerator.map do |document|
      object.new(document.properties)
    end
  end

  def fetch_object_by_id(id)
    doc = couchdb.document_with id
    if doc
      class_of_document_object(doc).new(doc.properties)
    end
  end

  # @param [CouchDB::Document] doc
  def class_of_document_object(doc)
    Class.getClass.forName(doc.property_for('$typ'))
    # self.getClass.forName(doc.property_for('$typ').toString)
    # .getConstructor().newInstance()
    # Object.const_get doc.property_for('$typ')
  end

  ############ Private ##############
  # private

  # @return [CouchDB]
  def couchdb
    @couchdb
  end

  def save_hash(hash)
    if hash[:_id] == nil
      doc = couchdb.create_document
    else
      doc = couchdb.document_with hash[:_id]
    end
    doc.put hash
  end


  # @return [CouchDB::Query]
  def query_for_view_name(name)
    db_view = couchdb.view_by name
    db_view.create_query
  end

  def enumerator_for_view_name(name)
    query_for_view_name(name).execute
  end
end