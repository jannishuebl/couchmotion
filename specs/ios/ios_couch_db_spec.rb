describe 'IOSCouchDB' do

  behaves_like 'AbstractCouchDB'

  def set_up_database
    CouchDB::IOSCouchDB.new 'test-database'
  end

  def document_class
    CouchDB::Document::IOSDocument
  end

end