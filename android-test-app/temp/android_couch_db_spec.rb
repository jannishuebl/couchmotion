describe 'AndroidCouchDB' do

  def set_up_database
    CouchDB::AndroidCouchDB.new 'test-db', self.main_activity.getApplicationContext
  end

  def document_class
    CouchDB::Document::AndroidDocument
  end

  behaves_like 'AbstractCouchDB'


end