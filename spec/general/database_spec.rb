require 'rspec'

require_relative '../../lib/general/database'
require_relative '../../lib/general/lazy_reference'


def create_test_object_with_reference(expected_typ_of_object_to_save, expected_typ_of_reference_object)
  reference_object = RefObject.new({:object => 'value'})
  object_to_save = TestObject.new({:test => 'hash', :ref => reference_object})
  expect(reference_object.class).to receive(:name).exactly(1).times.and_return(expected_typ_of_reference_object)
  expect(object_to_save.class).to receive(:name).and_return(expected_typ_of_object_to_save)
  object_to_save
end

def create_test_object_with_reference_list(expected_typ_of_object_to_save, expected_typ_of_reference_object)
  object_to_save = TestObject.new({:test => 'hash'})

  object_to_save.ref_list = []
  object_to_save.ref_list << create_new_ref_object(expected_typ_of_reference_object)
  object_to_save.ref_list << create_new_ref_object(expected_typ_of_reference_object)
  object_to_save.ref_list << create_new_ref_object(expected_typ_of_reference_object)

  expect(object_to_save.class).to receive(:name).and_return(expected_typ_of_object_to_save)
  object_to_save
end

def create_new_ref_object(expected_typ_of_reference_object)
  reference_object = RefObject.new({:object => 'value'})
  expect(reference_object.class).to receive(:name).and_return(expected_typ_of_reference_object)
  reference_object
end

def create_db_object_list
  expected_list = []
  expected_list << TestObject.new({:name => 'testobject1'})
  expected_list << TestObject.new({:name => 'testobject2'})
  expected_list << TestObject.new({:name => 'testobject3'})
  expected_list
end

def train_Pointer_for_error_handling
  expect(Pointer).to receive(:new).at_least(:once).and_return('pointer')
end

describe 'Databaseapi' do

  it 'can add a view to couchdb' do
    expected_map_return_value = 'map_block'
    expected_reduce_return_value = 'reduce_block'
    expected_version = 2
    view_class_name = 'test_view_class_name'

    view = create_view_double_with(expected_map_return_value, expected_reduce_return_value, expected_version, view_class_name)

    db_view = double('database_view')
    expect(db_view).to receive(:select_functions).with(expected_map_return_value, expected_reduce_return_value, expected_version)

    database = Database.instance
    couchdb = double('couchdb')
    expect(couchdb).to receive(:view_by).and_return(db_view)

    expect(database).to receive(:couchdb).and_return(couchdb)

    database.addView(view)
  end

  def couch_db_double_with_database_view(view_returned, view_class_name)
    couch_db = spy('database')
    expect(couch_db).to receive(:viewNamed).with(view_class_name[:view_name]).and_return(view_returned)
    couch_db
  end

  def create_view_double_with(expected_map_return_value, expected_reduce_return_value, expected_version, view_class_name)
    view = spy('view')
    expect(view).to receive(:map).and_return(expected_map_return_value)
    expect(view).to receive(:reduce).and_return(expected_reduce_return_value)
    expect(view).to receive(:version).and_return(expected_version)
    expect(view.class).to receive(:name).and_return(view_class_name)
    view
  end

  it 'can save a plain object and returns the id' do

    expected_id = 'id_of_object_to_save'

    object_to_save_class_name = 'object_to_save'
    object_to_save = double(object_to_save_class_name)
    object_data = {test:'hash'}

    expect(object_to_save).to receive(:to_h).and_return(object_data)
    expect(object_to_save.class).to receive(:name).once.and_return(object_to_save_class_name)

    database = Database.instance

    document = double('document')
    expect(document).to receive(:put).with(object_data).and_return(expected_id)

    couchdb = double('couchdb')
    expect(couchdb).to receive(:create_document).and_return(document)

    expect(database).to receive(:couchdb).and_return(couchdb)

    actual_id = database.save_object(object_to_save)

    expect(actual_id).to eq(expected_id)
  end

  it 'can save a object with references and returns the id' do

    id_of_reference_object = 'id_of_reference_object'
    id_of_object_to_save = 'id_of_object_to_save'

    expected_typ_of_reference_object = 'typ_of_reference_object'
    expected_typ_of_object_to_save = 'typ_of_object_to_save'

    object_to_save = create_test_object_with_reference(expected_typ_of_object_to_save, expected_typ_of_reference_object)

    database = Database.instance

    document_ref = double('ref document')
    expect(document_ref).to receive(:put).with({object:'value', _typ: expected_typ_of_reference_object}).and_return(id_of_reference_object)

    document_object = double('object document')
    expect(document_object).to receive(:put).with({:test => 'hash', :ref => {:_typ => 'ref', :_id => id_of_reference_object}, :_typ => expected_typ_of_object_to_save}).and_return(id_of_object_to_save)
    couchdb = double('couchdb')
    expect(couchdb).to receive(:create_document).and_return(document_ref, document_object)

    expect(database).to receive(:couchdb).twice.and_return(couchdb)

    id = database.save_object(object_to_save)

    expect(id).to eq(id_of_object_to_save)
  end

  it 'can save a object with a list of references and returns the id' do

    id_of_reference_object = 'id_of_reference_object'
    id_of_object_to_save = 'id_of_object_to_save'

    expected_typ_of_reference_object = 'typ_of_reference_object'
    expected_typ_of_object_to_save = 'typ_of_object_to_save'


    expected_hash_of_reference_list = {:_typ=>'col',
                                       :_ids=> %W(#{id_of_reference_object}1 #{id_of_reference_object}2 #{id_of_reference_object}3)}
    expected_hash_of_object = {:test => 'hash',
                               :ref_list => expected_hash_of_reference_list,
                               :_typ => expected_typ_of_object_to_save}

    object_to_save = create_test_object_with_reference_list(expected_typ_of_object_to_save, expected_typ_of_reference_object)


    database = Database.instance

    document_object = double('object document')
    expect(document_object).to receive(:put).with(expected_hash_of_object).and_return(id_of_object_to_save)
    couchdb = double('couchdb')
    expect(couchdb).to receive(:create_document).and_return(document_in_database_for_id("#{id_of_reference_object}1"),
                                                            document_in_database_for_id("#{id_of_reference_object}2"),
                                                            document_in_database_for_id("#{id_of_reference_object}3"),
                                                            document_object)

    expect(database).to receive(:couchdb).exactly(4).times.and_return(couchdb)

    id = database.save_object(object_to_save)

    expect(id).to eq(id_of_object_to_save)

  end

  def document_in_database_for_id(id)
    document_in_database = spy(id)
    expect(document_in_database).to receive(:put).with({:object=> 'value', :_typ=> 'typ_of_reference_object'}).and_return(id)
    document_in_database
  end

  it 'can fetch a list of objects by type' do

    expected_list = create_db_object_list

    database = Database.instance

    enumerator = double('enumerator')
    expect(enumerator).to receive(:map).and_return(expected_list)

    query = double(query)
    expect(query).to receive(:execute).and_return(enumerator)

    view = double('view')
    expect(view).to receive(:create_query).and_return(query)

    couchdb = double('couchdb')
    expect(couchdb).to receive(:view_by).and_return(view)

    expect(database).to receive(:couchdb).and_return(couchdb)

    result = TestObject.all

    expect(result).to eq(expected_list)
  end

  it 'can fetch a object by id and return correct implementation' do

    object_id = 'object_id'
    expected_data = {:_id => object_id, :name => 'object', :_typ=>'TestObject'}
    expected_object = TestObject.new(expected_data)

    document = double('document')
    expect(document).to receive(:property_for).with('_typ').and_return('TestObject')
    expect(document).to receive(:properties).and_return(expected_data)

    couchdb = double('couchdb')
    expect(couchdb).to receive(:document_with).with(object_id).and_return(document)

    database = Database.instance
    expect(database).to receive(:couchdb).and_return(couchdb)


    actual_object = database.fetch_object_by_id(object_id)

    expect(actual_object).to eq(expected_object)
  end

  # it 'can fetch a list of objects by type with refs' do
  #
  #   expected_list = create_db_object_list_with_refs_expected
  #   actual_list = create_db_object_list_with_refs_actual
  #
  #   couchdb = spy('database')
  #   database = Database.instance
  #   allow(database).to receive(:database).and_return(couchdb)
  #   train_Pointer_for_error_handling
  #
  #   view = spy('view')
  #   expect(couchdb).to receive(:viewNamed).with('TestObject').and_return(view)
  #   query = spy('query')
  #   expect(view).to receive(:createQuery).and_return(query)
  #   enumerator = spy('enumerator')
  #   expect(query).to receive(:run).and_return(enumerator)
  #
  #   expect(enumerator).to receive(:count).and_return(expected_list.size)
  #
  #   get_row_data enumerator, actual_list, 0
  #   get_row_data enumerator, actual_list, 1
  #   get_row_data enumerator, actual_list, 2
  #
  #   result = TestObject.all
  #
  #   expect(result).to eq(expected_list)
  # end
  #
  # def create_db_object_list_with_refs_expected
  #   expected_list = []
  #   expected_list << object_with_ref_expected(1)
  #   expected_list << object_with_ref_expected(2)
  #   expected_list << object_with_ref_expected(3)
  #   expected_list
  # end
  #
  # def object_with_ref_expected(index)
  #   ref = RefObject.new({:ref_name => "ref_name#{index}", :_id => "ref_id#{index}"})
  #   TestObject.new({:name => "testobject#{index}", :ref => ref})
  # end
  #
  #   def create_db_object_list_with_refs_actual
  #   expected_list = []
  #   expected_list << object_with_ref_actual(1)
  #   expected_list << object_with_ref_actual(2)
  #   expected_list << object_with_ref_actual(3)
  #   expected_list
  # end
  #
  # def object_with_ref_actual(index)
  #   TestObject.new({:name => "testobject#{index}", :ref => {:_id => "ref_id#{index}"}})
  # end

  def get_row_data(enumerator, expected_list, index)
    row = spy(row)
    document = spy(document)
    expect(row).to receive(:document).and_return(document)
    expect(document).to receive(:properties).and_return(expected_list[index])
    expect(enumerator).to receive(:rowAtIndex).with(index).and_return(row)
  end


end


class TestObject < DBObject

end

class RefObject < DBObject

end
class Pointer
end
