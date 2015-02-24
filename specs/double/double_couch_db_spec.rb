require 'helpers/spec_helper'

describe 'DoubleCouchDB' do

  include_examples 'AbstractCouchDB'

  def set_up_database
    CouchDB::DoubleCouchDB.new
  end

  def document_class
    CouchDB::Document::DoubleDocument
  end

end
