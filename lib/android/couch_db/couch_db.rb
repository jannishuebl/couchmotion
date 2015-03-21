class CouchDB

  module ClassMethods

    attr_accessor :manager, :databases
    def open_manager(context)
      context = Com::Couchbase::Lite::Android::AndroidContext.new context
      manager = Com::Couchbase::Lite::Manager.new context, Com::Couchbase::Lite::Manager::DEFAULT_OPTIONS
      @manager = Manager::AndroidManager.new manager
      true
    end

  end

end