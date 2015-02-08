require 'spec_helper'

describe 'CouchDB' do

  it 'should open and create a Double CouchDB implementation and close it' do

    result = CouchDB.open

    expect(result).to be true
    expect(CouchDB.instance_internal.couchdb).to be_kind_of(CouchDB::DoubleCouchDB)

    CouchDB.close
    expect(CouchDB.instance_internal.couchdb).to be_nil
  end

end