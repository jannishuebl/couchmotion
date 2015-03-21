shared 'CouchDB' do

  it 'should create a CouchDBManager and store it.' do

    result = open_manager

    expect(result).to be true
    expect(CouchDB.manager).to be_kind_of(manager_class)

    CouchDB.close
  end

  it 'should remove the manager and the databases.' do
    open_manager
    open_database :database_name

    CouchDB.close

    expect(CouchDB.manager).to be nil

    expect(CouchDB.databases).to eq Hash.new
  end

  it 'should open a database and store it.' do
    open_manager
    result = open_database :database_name

    expect(result).to be true
    expect(CouchDB.databases[:database_name].couchdb_impl).to be_kind_of(database_class)

    CouchDB.close
  end

  it 'should open multiple databases and store them.' do
    open_manager
    result = open_database :database_name1
    expect(result).to be true
    result = open_database :database_name2
    expect(result).to be true
    result = open_database :database_name3
    expect(result).to be true

    expect(CouchDB.databases[:database_name1].couchdb_impl).to be_kind_of(database_class)
    expect(CouchDB.databases[:database_name2].couchdb_impl).to be_kind_of(database_class)
    expect(CouchDB.databases[:database_name3].couchdb_impl).to be_kind_of(database_class)

    CouchDB.close
  end

  it 'should open multiple databases and give return them.' do
    open_manager
    result = open_database :database_name1
    expect(result).to be true
    result = open_database :database_name2
    expect(result).to be true
    result = open_database :database_name3
    expect(result).to be true

    expect(CouchDB.with_name(:database_name1).name).to eq(:database_name1)
    expect(CouchDB.with_name(:database_name2).name).to eq(:database_name2)
    expect(CouchDB.with_name(:database_name3).name).to eq(:database_name3)

    CouchDB.close
  end

  it 'should return the first added by default.' do
    open_manager
    result = open_database :database_name1
    expect(result).to be true
    result = open_database :database_name2
    expect(result).to be true
    result = open_database :database_name3
    expect(result).to be true

    expect(CouchDB.database.name).to eq(:database_name1)

    CouchDB.close
  end

  def open_manager
    raise NotImplementedError
  end

  def manager_class
    raise NotImplementedError
  end

  def open_database(_)
    raise NotImplementedError
  end

  def database_class
    raise NotImplementedError
  end

end