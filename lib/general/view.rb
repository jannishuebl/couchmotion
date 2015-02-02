class CouchDbFacade
  class View
    def select_functions(map_block, reduce_block, version)
      raise NotImplementedError
    end

    # @return [CouchDB::Query]
    def create_query
      raise NotImplementedError
    end
  end
  class Query

    def execute
      raise NotImplementedError
    end

  end
  class Enumerator

    def map(&block)
      raise NotImplementedError
    end

  end
end
