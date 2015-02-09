require 'helpers/spec_helper'

describe 'CouchDB' do

  include_examples 'Initialize CouchDB'

  def open_database
    CouchDB.open
  end

  def database_class
    CouchDB::DoubleCouchDB
  end
end