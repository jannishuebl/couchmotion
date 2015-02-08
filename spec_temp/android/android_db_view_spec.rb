require 'rspec'

require_relative '../../lib/general/couch_db'
require_relative '../../lib/android/database/document'
require_relative '../../lib/android/database/view'
require_relative '../../lib/android/database/query'


describe 'CouchDbFacade:View::Android' do

  it 'extends CouchDbFacade::View' do
    db_view = double('db_view')
    view= CouchDbFacade::View::AndroidView.new db_view
    expect(view).to be_kind_of(CouchDbFacade::View)
  end

  it 'can add selection functions' do
    db_view = double('db_view')
    expect(db_view).to receive(:setMapReduce).with('mapblock', 'reduce_block', 'version')
    view = CouchDbFacade::View::AndroidView.new db_view
    view.select_functions('mapblock', 'reduce_block', 'version')
  end

  it 'can create a query' do

    db_query = double('db_query')
    db_view = double('db_view')
    expect(db_view).to receive(:createQuery).and_return(db_query)
    view = CouchDbFacade::View::AndroidView.new db_view
    query = view.create_query

    expect(query.instance_variable_get(:@android_query)).to be(db_query)
  end

end
