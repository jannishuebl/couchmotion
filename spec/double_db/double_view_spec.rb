require 'spec_helper'

def setup_database
  database = reset_database
  fill database
  database
end

describe 'DoubleView' do

  it 'should get a map block which gets all documents and a working emiter' do
    database = setup_database

    view = database.view_by 'test-view'

    mapped_documents = []
    result = view.map do |document, emitter|
      expect(document).to be_kind_of CouchDB::Document::DoubleDocument
      expect(emitter).to be_kind_of CouchDB::View::DoubleView

      mapped_documents << document
      if document.properties[:string]
        emitter.emit document.properties[:string], nil
      end
    end
    expect(result).to be false

    result = view.version 1
    expect(result).to be true


    view.create_query.execute

    expect(mapped_documents.size).to eq 3

    database.destroy
  end

  it 'should get a map block and a reduce block which gets, keys, values and rereduce' do
    database = setup_database

    view = database.view_by 'test-view'

    mapped_documents = []
    view.map do |document, emitter|

      expect(document).to be_kind_of CouchDB::Document::DoubleDocument
      expect(emitter).to be_kind_of CouchDB::View::DoubleView

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
      expect(keys.size).to eq 3
      actual_values = values.include? 'value1'
      actual_keys = keys.include? 'string1'
      actual_rereduce = rereduce
      123
    end

    view.version 1


    enumerator = view.create_query.execute
    reduce_value = enumerator.reduce_value

    expect(reduce_value).to eq 123
    expect(actual_keys).to be true
    expect(actual_values).to be true
    expect(actual_rereduce).to be false

    database.destroy
  end

  def property_should_be(actual, clazz, expected)
  end

end

def reset_database
  database = CouchDB::DoubleCouchDB.new
  database.destroy
  CouchDB::DoubleCouchDB.new
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
