require 'rspec'

require_relative '../../lib/general/couch_db'
require_relative '../../lib/android/database/document'
require_relative '../../lib/android/database/view'
require_relative '../../lib/android/database/enumerator'
require_relative '../../lib/android/database/query'


describe 'CouchDbFacade:Enumerator::Android' do

  it 'can create a query' do
    db_enumerator = double('db_enumerator')
    expect(db_enumerator).to receive(:getCount).and_return(2)

    android_document1 = double('android_document1')
    expect(android_document1).to receive(:getProperties).and_return('prop1')

    row1 = double('row1')
    expect(row1).to receive(:getDocument).and_return(android_document1)

    android_document2 = double('android_document2')
    expect(android_document2).to receive(:getProperties).and_return('prop2')

    row2 = double('row2')
    expect(row2).to receive(:getDocument).and_return(android_document2)

    expect(db_enumerator).to receive(:getRow).and_return(row1, row2)

    enumerator = CouchDbFacade::Enumerator::AndroidEnumerator.new db_enumerator

    map = enumerator.map do | document |
      document.properties
    end

    expect(map).to eq(['prop1', 'prop2'])
  end

end
class Pointer
end
