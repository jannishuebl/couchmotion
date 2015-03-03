shared 'AbstractCouchModel' do

  it 'should save it self to default database. and return instance of it self with new id. There should be a class method which retuns a object for a id' do
    open_database

    test_model = TestCouchModel.new

    test_model.name = 'test'

    id = test_model.save._id

    expect(id).not_to be(nil)

    db_test_model = TestCouchModel.fetch_by_id id

    expect(db_test_model.name).to eq test_model.name
    expect(db_test_model._id).to eq id

    CouchDB.destroy
    CouchDB.close
  end

  it 'should save it self to default database. and return instance of it self with new id. There should be a class method which retuns a object for a id' do
    open_database

    test_model = TestCouchModel.new

    test_model.name = 'test'

    test_model.save!

    expect(test_model._id).not_to be(nil)

    CouchDB.destroy
    CouchDB.close
  end

  it 'should update it self to default database.' do
    open_database

    test_model = TestCouchModel.new({name: 'test'})

    test_model.save!

    expect(test_model._id).not_to be(nil)

    test_model.name = 'test2'
    test_model.test = 'test2'

    test_model_update = test_model.save

    expect(test_model_update.name).to eq('test2')
    expect(test_model_update.test).to eq('test2')

    test_model_db = TestCouchModel.fetch_by_id(test_model_update._id)

    expect(test_model_db.name).to eq('test2')
    expect(test_model_db.test).to eq('test2')

    CouchDB.destroy
    CouchDB.close
  end

  it 'should update it self to default database.' do
    open_database

    test_model = TestCouchModel.new({name: 'test'})

    test_model.save!

    expect(test_model._id).not_to be(nil)

    test_model.name = 'test2'
    test_model.test = 'test2'

    test_model.save!

    expect(test_model.name).to eq('test2')
    expect(test_model.test).to eq('test2')

    test_model_db = TestCouchModel.fetch_by_id(test_model._id)

    expect(test_model_db.name).to eq('test2')
    expect(test_model_db.test).to eq('test2')

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


  it 'should persist collections.' do
    open_database

    test_model = TestCouchModel.new
    test_model_col1 = TestCouchModel.new
    test_model_col2 = TestCouchModel.new

    test_model.col << test_model_col1
    test_model.col << test_model_col2

    cols = test_model.to_db_hash['col']

    expect(cols[0]).to eq({type: 'TestCouchModel', id: test_model_col1._id})
    expect(cols[1]).to eq({type: 'TestCouchModel', id: test_model_col2._id})


    CouchDB.destroy
    CouchDB.close
  end

  it 'should create lazy collection for persisted collections' do
    open_database

    test_model = TestCouchModel.new
    test_model_col1 = TestCouchModel.new
    test_model_col2 = TestCouchModel.new

    test_model.col << test_model_col1
    test_model.col << test_model_col2

    db_model = test_model.save

    expect(db_model.to_h['col']).to be_kind_of(LazyCollection)

    db_model.save!

    expect(db_model.col[0]._id).to eq(test_model_col1._id)
    expect(db_model.col[1]._id).to eq(test_model_col2._id)


    CouchDB.destroy
    CouchDB.close

  end

  it 'should give the possibility to add fields that are not of a elementary type' do
    open_database


    expected_currency = Currency.new({curr: 'euro'})

    test_model = TestCouchModel.new

    test_model.currency = expected_currency

    test_model.save!

    test_model2 = TestCouchModel.fetch_by_id(test_model._id)

    expect(test_model2.currency.to_h).to eq(expected_currency.to_h)

    CouchDB.destroy
    CouchDB.close
  end

  it 'should tell if it is persisted or is not' do
    open_database

    test_model = TestCouchModel.new

    expect(test_model.persisted?).to be false

    test_model_saved = test_model.save

    expect(test_model_saved.persisted?).to be true

    CouchDB.destroy
    CouchDB.close
  end

  it 'should accept a hash and add it to it selfs fields' do
    open_database

    test_model = TestCouchModel.new({test: 'hallo', test2:'hallo'})

    test_model.add_hash({test2:'hallo2', test3:'hallo3'})

    expect(test_model.test).to eq 'hallo'
    expect(test_model.test2).to eq 'hallo2'
    expect(test_model.test3).to eq 'hallo3'

  end

  it 'should can be refreshed' do
    open_database

    test_model = TestCouchModel.new({test: 'hallo', test2:'hallo'})

    test_model = test_model.save

    test_model2 = TestCouchModel.fetch_by_id(test_model._id)
    test_model2.test = 'test'
    test_model2.save


    test_model = test_model.refresh

    expect(test_model.test).to eq 'test'
  end

  it 'should can be refreshed! and new is in self' do
    open_database

    test_model = TestCouchModel.new({test: 'hallo', test2:'hallo'})

    test_model = test_model.save

    test_model2 = TestCouchModel.fetch_by_id(test_model._id)
    test_model2.test = 'test'
    test_model2.save


    test_model.refresh!

    expect(test_model.test).to eq 'test'
  end


  it 'should can be deleted' do
    open_database

    test_model = TestCouchModel.new({test: 'hallo', test2:'hallo'})
    test_model = test_model.save

    test_model2 = TestCouchModel.fetch_by_id(test_model._id)
    success = test_model2.delete

    expect(success).to be true

    test_model2 = TestCouchModel.fetch_by_id(test_model._id)
    expect(test_model2.test).to be nil
    expect(test_model2.test2).to be nil
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


class Currency

  def initialize(hash)
    @hash = hash
  end

  def to_h
    @hash
  end

  def equal?(other)
    @hash.equal? other.to_h
  end
end

class TestCouchModel < CouchModel

  collection :col
  field :currency, class: Currency, to: Proc.new { | hash | Currency.new(hash) }, from: Proc.new {| currency | currency.to_h}

end
class TestCouchModel2 < CouchModel

  collection :col2

end
