describe 'IOSDocument' do

  behaves_like 'AbstractDocument'

  def set_up_database
    CouchDB::IOSCouchDB.new 'test-database'
  end

end