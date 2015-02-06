def setup_database
  database = reset_database
  fill database
  database
end

describe 'IOSView' do

  it 'should get a map block which gets all documents and a working emiter' do
    database = setup_database

    view = database.view_by 'test-view'

    mapped_documents = []
    result = view.map do |document, emitter|
      document.should.kind_of CouchDB::Document::IOSDocument
      emitter.should.kind_of CouchDB::View::IOSView::IOSEmitter

      mapped_documents << document
      if document.properties[:string]
        emitter.emit document.properties[:string], nil
      end
    end
    result.should == false

    result = view.version 1
    result.should == true

    view.create_query.execute

    mapped_documents.size.should == 3

    database.destroy
  end

  it 'should get a map block and a reduce block which gets, keys, values and rereduce' do
    database = setup_database

    view = database.view_by 'test-view'

    mapped_documents = []
    view.map do |document, emitter|

      document.should.kind_of CouchDB::Document::IOSDocument
      emitter.should.kind_of CouchDB::View::IOSView::IOSEmitter

      mapped_documents << document
      if document.properties[:string]
        emitter.emit document.properties[:string], 'value1'
        emitter.emit document.properties[:string], nil
        emitter.emit document.properties[:string], nil
      end
    end

    actual_keys = -1
    actual_values = -1
    actual_rereduce = -1

    view.reduce do |keys, values, rereduce|
      keys.size.should == 3
      actual_values = values.include? 'value1'
      actual_keys = keys.include? 'string1'
      actual_rereduce = rereduce
      123
    end

    view.version 1


    enumerator = view.create_query.execute
    reduce_value = enumerator.reduce_value

    reduce_value.should.equal 123
    actual_keys.should == true
    actual_values.should == true
    actual_rereduce.should == false

    database.destroy
  end

  def property_should_be(actual, clazz, expected)
  end

end

def reset_database
  database = CouchDB::IOSCouchDB.new 'test-db'
  database.destroy
  CouchDB::IOSCouchDB.new 'test-db'
end

# @param [CouchDB::AndroidCouchDB] database
def fill(database)
  doc = database.create_document
  doc.put({string: 'string1'})
  doc2 = database.create_document
  doc2.put({integer: 123})
  doc3 = database.create_document
  doc3.put({float: 12.3})
end
