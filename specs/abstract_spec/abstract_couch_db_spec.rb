shared 'AbstractCouchDB' do

  it 'should create a new document' do
    database = set_up_database

    document = database.create_document

    puts expect(document).to be_kind_of document_class

    database.destroy
  end

  it 'should get a document by id' do
    database = set_up_database

    old_document = database.create_document
    old_document.put({name:123})

    id = old_document.property_for :_id

    new_document = database.document_with id

    expect(new_document).to be_kind_of document_class
    expect(new_document.property_for(:name)).to eq 123

    database.destroy
  end


  def set_up_database
    raise NotImplementedError
  end

  def document_class
    raise NotImplementedError
  end


end