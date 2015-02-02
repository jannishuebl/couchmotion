require 'rspec'

require_relative '../../lib/general/couch_db'
require_relative '../../lib/android/database/document'
require_relative '../../lib/android/database/view'
require_relative '../../lib/android/database/enumerator'
require_relative '../../lib/android/database/query'


describe 'CouchDbFacade:Query::Android' do

  it 'extends CouchDbFacade::Query' do
    db_query = double('db_query')
    query= CouchDbFacade::Query::AndroidQuery.new db_query
    expect(query).to be_kind_of(CouchDbFacade::Query)
  end

  it 'can create a query' do

    db_enumerator = double('db_enumerator')
    db_view = double('db_view')
    expect(db_view).to receive(:run).and_return(db_enumerator)
    query = CouchDbFacade::Query::AndroidQuery.new db_view
    enumerator = query.execute

    expect(enumerator.instance_variable_get(:@android_enumerator)).to be(db_enumerator)
  end

end
