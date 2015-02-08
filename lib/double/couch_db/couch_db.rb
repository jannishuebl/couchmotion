class CouchDB

  def self.open
    CouchDB.implementation = DoubleCouchDB.new 
    true
  end

end
