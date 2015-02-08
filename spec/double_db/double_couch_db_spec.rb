require 'spec_helper'

describe 'DoubleCouchDB' do

  it 'should create a new document' do
    database = CouchDB::DoubleCouchDB.new

    document = database.create_document

    expect(document).to be_kind_of CouchDB::Document::DoubleDocument

    database.destroy
  end

  it 'should get a document by id' do
    database = CouchDB::DoubleCouchDB.new

    old_document = database.create_document
    old_document.put({name:123})

    id = old_document.property_for :_id

    new_document = database.document_with id

    expect(new_document).to be_kind_of CouchDB::Document::DoubleDocument
    expect(new_document.property_for(:name)).to be 123

    database.destroy
  end
end