describe 'AndroidQuery' do

  def set_up_database
    CouchDB::AndroidCouchDB.new 'test-db', self.main_activity.getApplicationContext
  end

  behaves_like 'AbstractQuery'

end

