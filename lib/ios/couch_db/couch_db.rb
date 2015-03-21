
module CouchDB

  module ClassMethods

    attr_accessor :manager, :databases
    def open_manager
      @manager = Manager::IOSManager.new
      true
    end
  end

end
