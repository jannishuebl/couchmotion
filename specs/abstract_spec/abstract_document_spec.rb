shared 'AbstractDocument' do

  it 'should put properties to the document and stores them and return a id and return correct values again' do
    database = set_up_database

    document = database.create_document
    id = document.put({string: 'string', integer: 123, float: 12.4})

    expect(id).not_to be nil
    expect(id).to be_kind_of String

    document = database.document_with id
    properties = document.properties


    expect(properties[:string]).to eq 'string'
    expect(properties[:integer]).to eq 123
    expect(properties[:float]).to eq 12.4

    expect(document.property_for(:string)).to eq 'string'
    expect(document.property_for(:integer)).to eq 123
    expect(document.property_for(:float)).to eq 12.4
  end

  def set_up_database
    raise NotImplementedError
  end

end