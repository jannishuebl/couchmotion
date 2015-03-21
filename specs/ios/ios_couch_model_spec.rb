
describe 'IOSCouchModel' do

  behaves_like  'AbstractCouchModel'

  def open_database
    CouchDB.open_manager
    CouchDB.open 'testdb2'
  end

end
