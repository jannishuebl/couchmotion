require 'helpers/spec_helper'

describe 'DoubleDocument' do

  include_examples 'AbstractDocument'

  def set_up_database
    CouchDB::DoubleCouchDB.new
  end

end