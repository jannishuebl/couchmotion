class DBObject


  def reduce
    nil
  end

  def version
    '35'
  end

  def self.all
    Database.object_list_for_object_class self
  end

  def self.for_id(id)
    Database.fetch_object_by_id(id)
  end

  def map
    Proc.new do |doc, emit|
      if doc[:typ] == self.class.name
        emit.call nil, nil
      end
    end
  end

  def save
    Database.save_object self
  end

  def get_table_element(id)
    element = table[id]
    if element.kind_of?(Lazy)
      element = element.real_object
    end
    element
  end

  def initialize(hash=nil)
    @table = {}
    if hash
      hash.each_pair do |k, v|
        k = k.to_sym.id2name
        @table[k] = v
        if is_element_a_reference(v)
          @table[k] = LazyReference.new(v[:_id])
        elsif is_element_a_collection(v)
          @table[k] = LazyCollection.new(v[:_ids])
        end
      end
    end
  end


  def is_element_a_collection(v)
    v.kind_of?(Hash) && v.has_key?(:_typ) && v[:_typ] == 'col'
  end

  def is_element_a_reference(v)
    v.kind_of?(Hash) && v.has_key?(:_id) && v.has_key?(:_typ) && v[:_typ] == 'ref'
  end
end
