describe 'AndroidQuery' do

  it 'should select documents by string keys and return a enumerator' do

    query = setup_query_with_view_for_property :string

    query.with_keys ['string1', 'string2']

    expected_documents = [1, 2, 3]
    test_if_enumerator_contains_expected_documents(expected_documents, query)
  end

  it 'should select documents by string key and return a enumerator' do
    query = setup_query_with_view_for_property :string

    query.with_key 'string1'

    expected_documents = [1, 3]
    test_if_enumerator_contains_expected_documents(expected_documents, query)
  end

  it 'should select documents by integer keys and return a enumerator' do
    query = setup_query_with_view_for_property :integer

    query.with_keys [123, 321]

    expected_documents = [5, 6, 7]
    test_if_enumerator_contains_expected_documents(expected_documents, query)
  end

  it 'should select documents by integer key and return a enumerator' do
    query = setup_query_with_view_for_property :integer

    query.with_key 987

    expected_documents = [8]
    test_if_enumerator_contains_expected_documents(expected_documents, query)
  end

  it 'should select documents by float keys and return a enumerator' do
    query = setup_query_with_view_for_property :float

    query.with_keys [12.3, 3.21]

    expected_documents = [9, 10, 11]
    test_if_enumerator_contains_expected_documents(expected_documents, query)
  end

  it 'should select documents by float key and return a enumerator' do
    query = setup_query_with_view_for_property :float

    query.with_key 9.87

    expected_documents = [12]
    test_if_enumerator_contains_expected_documents(expected_documents, query)
  end

end

def reset_database
  database = CouchDB::AndroidCouchDB.new 'test-db', self.main_activity.getApplicationContext
  database.destroy
  CouchDB::AndroidCouchDB.new 'test-db', self.main_activity.getApplicationContext
end

def setup_query_with_view_for_property(property)
  database = reset_database

  fill_for_query database

  view = database.view_by 'test-view'

  view.map do |document, emitter|

    if document.properties[property]
      emitter.emit document.properties[property], nil
    end
  end
  view.version 1


  view.create_query
end


def test_if_enumerator_contains_expected_documents(expected_documents, query)
  enumerator = query.execute

  documents = []
  enumerator.map do |key, document|
    documents << document.property_for(:document)
  end

  test_arrays_are_equal(documents, expected_documents)
end


def test_arrays_are_equal(actual, expected)
  actual.size.should.equal expected.size
  expected.each do |x|
    unless actual.include? x
      puts "Actual:#{actual} does not contain: #{expected}"
    end
    actual.include?(x).should == true
  end
end

def fill_for_query(database)
  doc = database.create_document
  doc.put({string: 'string1', document: 1})
  doc = database.create_document
  doc.put({string: 'string2', document: 2})
  doc = database.create_document
  doc.put({string: 'string1', document: 3})
  doc = database.create_document
  doc.put({string: 'string3', document: 4})
  doc2 = database.create_document
  doc2.put({integer: 123, document: 5})
  doc2 = database.create_document
  doc2.put({integer: 123, document: 6})
  doc2 = database.create_document
  doc2.put({integer: 321, document: 7})
  doc2 = database.create_document
  doc2.put({integer: 987, document: 8})
  doc3 = database.create_document
  doc3.put({float: 12.3, document: 9})
  doc3 = database.create_document
  doc3.put({float: 12.3, document: 10})
  doc3 = database.create_document
  doc3.put({float: 3.21, document: 11})
  doc3 = database.create_document
  doc3.put({float: 9.87, document: 12})
end
