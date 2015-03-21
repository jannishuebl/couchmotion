require 'helpers/spec_helper'

describe 'DoubleCouchModel' do

  include_examples 'AbstractCouchModel'

  def open_database
    CouchDB.open_manager
    CouchDB.open 'testdb'
  end

end
