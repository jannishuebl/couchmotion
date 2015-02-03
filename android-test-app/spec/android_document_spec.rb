
describe 'AndroidDocument' do

  it 'should put properties to the document and stores them and return a id and return correct values again' do

    database = CouchDB::AndroidCouchDB.new 'test-db', self.main_activity.getApplicationContext

    document = database.create_document
    id = document.put({string: 'string', integer: 123, float: 12.4})

    id.should != nil
    id.class.name.should.equal 'com.rubymotion.String'

    document = database.document_with id
    properties = document.properties


    properties[:string].should.be.equal 'string'
    properties[:integer].should.be.equal 123
    properties[:float].should.be.equal 12.4

    document.property_for(:string).should.be.equal 'string'
    document.property_for(:integer).should.be.equal 123
    document.property_for(:float).should.be.equal 12.4
  end

  def property_should_be(actual, clazz, expected)
  end

end