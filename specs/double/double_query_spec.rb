require 'helpers/spec_helper'

describe 'DoubleQuery' do

  include_examples 'AbstractQuery'

  def set_up_database
    CouchDB::DoubleCouchDB.new
  end
end

