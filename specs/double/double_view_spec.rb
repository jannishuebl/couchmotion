require 'helpers/spec_helper'

describe 'DoubleView' do

  include_examples 'AbstractView'

  def set_up_database
    CouchDB::DoubleCouchDB.new
  end

  def document_class
    CouchDB::Document::DoubleDocument
  end

  def emitter_class
    CouchDB::View::DoubleView
  end
end

