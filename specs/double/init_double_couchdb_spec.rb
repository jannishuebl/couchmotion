require 'helpers/spec_helper'

describe 'CouchDB' do

  include_examples 'CouchDB'

  def open_manager
    CouchDB.open_manager
  end

  def manager_class
    CouchDB::Manager::DoubleManager
  end

  def open_database(database_name)
    CouchDB.open database_name
  end

  def database_class
    CouchDB::DoubleCouchDB
  end
end