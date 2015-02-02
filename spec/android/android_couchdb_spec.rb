require 'rspec'

require_relative '../../lib/general/couch_db'
require_relative '../../lib/android/database/document'
require_relative '../../lib/android/database/view'
require_relative '../../lib/android/database/android_couch_db'


describe 'AndroidCouchDB' do

  # @return [CouchDbFacade::AndroidCouchDB]
  def android_couchdb
    CouchDbFacade::AndroidCouchDB.new 'database_name', double('contex')
  end

  it 'extends CouchDbFacade' do
    expect(android_couchdb).to be_kind_of CouchDbFacade
  end

  it 'can return a new Document' do
    db_document = double('db_document')

    android_test_couchdb = double('android_couchdb')
    expect(android_test_couchdb).to receive(:createDocument).and_return(db_document)

    database = android_couchdb
    expect(database).to receive(:database).and_return(android_test_couchdb)


    document = database.create_document

    expect(document).to be_kind_of CouchDbFacade::Document::AndroidDocument
    expect(document.instance_variable_get(:@android_document)).to eq(db_document)
  end

  it 'can return a DatabaseView by name' do

    view_name = 'test_view'

    db_view = double('db_view')

    android_test_couchdb = double('android_couchdb')
    expect(android_test_couchdb).to receive(:getView).with(view_name).and_return(db_view)

    database = android_couchdb
    expect(database).to receive(:database).and_return(android_test_couchdb)

    view = database.view_by view_name


    expect(view).to be_kind_of CouchDbFacade::View::AndroidView
    expect(view.instance_variable_get(:@android_view)).to eq(db_view)

  end

  it 'can return a Document by id' do
    document_id = 'document_id'

    db_document = double('db_document')

    android_test_couchdb = double('android_couchdb')
    expect(android_test_couchdb).to receive(:getDocument).with(document_id).and_return(db_document)

    database = android_couchdb
    expect(database).to receive(:database).and_return(android_test_couchdb)


    document = database.document_with document_id

    expect(document).to be_kind_of CouchDbFacade::Document::AndroidDocument
    expect(document.instance_variable_get(:@android_document)).to eq(db_document)

  end
end

class IOSCouchDB < CouchDbFacade
end
