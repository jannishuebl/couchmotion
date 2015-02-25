shared 'AbstractCouchModel' do

  it 'should save it self to default database. and return instance of it self with new id. There should be a class method which retuns a object for a id' do
    open_database

    test_model = TestCouchModel.new

    test_model.name = 'test'

    id = test_model.save._id

    expect(id).not_to be(nil)

    db_test_model = TestCouchModel.fetch_by_id id

    expect(db_test_model.name).to eq test_model.name
    expect(db_test_model._id).to eq test_model._id

    CouchDB.destroy
    CouchDB.close
  end

  it 'should return a list of all Models.' do
    open_database
    db_models = insert_test_models

    models = TestCouchModel.all

    expect_list_contains_same_models(models, db_models)

    CouchDB.destroy
    CouchDB.close
  end

  def expect_list_contains_same_models(actual, expected)
    expect(actual.size).to eq expected.size
    count = expected.size
    actual.each do | actual_model |
      expected.each do | expected_model|
        if(actual_model.name == expected_model.name)
          count = count - 1
        end
      end
    end
    expect(count).to be 0
  end

  def open_database
    raise NotImplementedError
  end

end

def insert_test_models
  other_models.each do | model|
    model.save
  end
  all_models.map do | model |
    model.save
  end
end

def other_models
  all_models = []
  all_models << TestCouchModel2.new({name: 'test3'})
  all_models << TestCouchModel2.new({name: 'test3'})
  all_models << TestCouchModel2.new({name: 'test3'})
  all_models
end


def all_models
  all_models = []
  all_models << TestCouchModel.new({name: 'test1'})
  all_models << TestCouchModel.new({name: 'test2'})
  all_models << TestCouchModel.new({name: 'test3'})
  all_models
end



class TestCouchModel < CouchModel

end