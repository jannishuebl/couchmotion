describe 'AndroidView' do

  def set_up_database
    CouchDB::AndroidCouchDB.new 'test-db', self.main_activity.getApplicationContext
  end

  def document_class
    CouchDB::Document::AndroidDocument
  end

  def emitter_class
    CouchDB::View::AndroidView::AndroidEmitter
  end

  behaves_like 'AbstractView'


end

