describe 'IOSView' do

  behaves_like 'AbstractView'

  def set_up_database
    CouchDB::IOSCouchDB.new 'test-database'
  end

  def document_class
    CouchDB::Document::IOSDocument
  end

  def emitter_class
    CouchDB::View::IOSView::IOSEmitter
  end

end

