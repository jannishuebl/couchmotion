motion_require 'couch_db/couch_db_impl'
motion_require 'utils/couchstruct'

class CouchModel < CouchStruct

  def self.view_for_type(view_name, options)

    class_type = self.name
    class_type = options[:type].name if options[:type]

    map = Proc.new do | document , emitter|
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
    view_for_type :all_for_type, map: Proc.new { |doc, emitter| emitter.emit doc.property_for(:model_type), nil }, type: subclass
  end


  def self.all
    query = CouchDB.view_by(:all_for_type).create_query
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
    self.new CouchDB.document_with(id).properties
  end


  def save
    document = CouchDB.create_document
    self.model_type = self.class.name
    self._id = document.put self.to_h
    self
  end

end
class TestCouchModel2 < CouchModel

  collection :member

end
