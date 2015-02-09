describe 'IOSQuery' do

  behaves_like 'AbstractQuery'

  def set_up_database
    CouchDB::IOSCouchDB.new 'test-database'
  end

end

