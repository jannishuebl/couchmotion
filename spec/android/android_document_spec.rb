require 'rspec'

require_relative '../../lib/general/couch_db'
require_relative '../../lib/android/database/document'
require_relative '../../lib/android/database/view'
require_relative '../../lib/android/database/enumerator'
require_relative '../../lib/android/database/query'


describe 'CouchDbFacade:Document::Android' do

  it 'extends CouchDbFacade' do
    db_document = double('db_document')
    document = CouchDbFacade::Document::AndroidDocument.new db_document
    expect(document).to be_kind_of(CouchDbFacade::Document)
  end

  it 'can put properties to db_document' do
    db_document = double('db_document')
    properties = {_id:'id', name:'test'}


    expect(db_document).to receive(:putProperties).with(properties).and_return(db_document)
    expect(db_document).to receive(:getProperty).with('_id').and_return('id')


    document = CouchDbFacade::Document::AndroidDocument.new db_document
    id = document.put(properties)

    expect(id).to eq('id')
  end

  it 'can return a property for a key' do
    db_document = double('db_document')

    expect(db_document).to receive(:getProperty).with('_id').and_return('id')


    document = CouchDbFacade::Document::AndroidDocument.new db_document
    id = document.property_for('_id')

    expect(id).to eq('id')
  end

  it 'can return a property for a key' do
    db_document = double('db_document')

    expected_properties = {_id:'id', name:'test'}
    expect(db_document).to receive(:getProperties).and_return(expected_properties)


    document = CouchDbFacade::Document::AndroidDocument.new db_document
    actual_properties = document.properties

    expect(actual_properties).to eq(expected_properties)
  end

end
class Pointer
end
