require 'rspec'

require_relative '../../lib/general/utils/ostruct'
require_relative '../../lib/general/database'
require_relative '../../lib/general/db_object'



describe 'Databaseobject' do

  it 'can fetch a list of it' do

    expected_list = create_db_object_list

    database = Database.instance
    expect(database).to receive(:object_list_for_object_class).with(TestObject).and_return(expected_list)

    result = TestObject.all

    expect(result).to eq(expected_list)
  end

  it 'can fetch a object by id' do

    expected_object = TestObject.new({:name => 'testobject', :_id=>'id_of_object'})

    database = Database.instance
    expect(database).to receive(:fetch_object_by_id).with('id_of_object').and_return(expected_object)

    result = TestObject.for_id 'id_of_object'

    expect(result).to eq(expected_object)
  end
  it 'can load a reference object when it is required' do

    object = TestObject.new({:_id => 'object_id', :ref => {:_id => 'ref_id', :_typ=>'ref'}})
    ref_object = TestObject.new({:_id => 'ref_id', :name => 'name'})

    database = Database.instance
    expect(database).to receive(:fetch_object_by_id).with('ref_id').and_return(ref_object)

    expect(object.ref).to eq(ref_object)

  end


  it 'can load a collection of object when it is required' do

    ref_ids = [ref_hash(1), ref_hash(2), ref_hash(3)]
    object = TestObject.new({:_id => 'object_id', :ref => {:_typ=>'col', :_ids => ref_ids}})

    database = Database.instance

    ref_object_list = []
    ref_object_list << ref_object(1, database)
    ref_object_list << ref_object(2, database)
    ref_object_list << ref_object(3, database)


    expect(object.ref).to eq(ref_object_list)
  end
end

def ref_hash(index)
  "ref_id#{index}"
end

def ref_object(index, database)
  ref_object = TestObject.new({:_id => "ref_id#{index}", :name => "name#{index}"})
  expect(database).to receive(:fetch_object_by_id).with("ref_id#{index}").and_return(ref_object)
  ref_object
end

def create_db_object_list
  expected_list = []
  expected_list << TestObject.new({:name => 'testobject1'})
  expected_list << TestObject.new({:name => 'testobject2'})
  expected_list << TestObject.new({:name => 'testobject3'})
  expected_list
end
class TestObject < DBObject

end
