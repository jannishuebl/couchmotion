
class CouchStruct

  def self.field(name, options={})
    options[:name] = name
    @fields ||= []
    @fields << options
  end

  def self.fields
    @fields ||= []
    @fields
  end

  def self.collection(field)
    @collections ||= []
    @collections << field
  end

  def self.collections
    @collections ||= []
    @collections
  end


  def initialize(hash={})
    marshal_load(hash)
  end

  def to_db_hash
    hash = to_h
    self.class.collections.each do |collection|
      hash[collection.to_s] = hash[collection.to_s].db_objects
    end
    self.class.fields.each do |field|
      field_data = hash[field[:name].to_s]
      if field_data
        hash[field[:name].to_s] = field[:from].call field_data
      end
    end
    hash
  end

  def is_element_a_collection(v)
    v.kind_of?(Hash) && v.has_key?(:_typ) && v[:_typ] == 'col'
  end

  def is_element_a_reference(v)
    v.kind_of?(Hash) && v.has_key?(:_id) && v.has_key?(:_typ) && v[:_typ] == 'ref'
  end

  #
  # Converts the OpenStruct to a hash with keys representing
  # each attribute (as symbols) and their corresponding values
  # Example:
  #
  #   require 'ostruct'
  #   data = OpenStruct.new("country" => "Australia", :population => 20_000_000)
  #   data.to_h   # => {:country => "Australia", :population => 20000000 }
  #
  def to_h
    @table.dup
  end

  #
  # Yields all attributes (as a symbol) along with the corresponding values
  # or returns an enumerator if not block is given.
  # Example:
  #
  #   require 'ostruct'
  #   data = OpenStruct.new("country" => "Australia", :population => 20_000_000)
  #   data.each_pair.to_a  # => [[:country, "Australia"], [:population, 20000000]]
  #
  def each_pair
    return to_enum(__method__) { @table.size } unless block_given?
    @table.each_pair { |p| yield p }
  end

  #
  # Provides marshalling support for use by the Marshal library.
  #
  # def marshal_dump
  #   @table
  # end

  #
  # Provides marshalling support for use by the Marshal library.
  #
  def marshal_load(hash)
    hash = {} unless hash
    col_hash = {}
    self.class.collections.each do |collection|

      if hash[collection]
        col_hash[collection] = LazyCollection.new(hash[collection], self)
      else
        col_hash[collection] = LazyCollection.new([], self)
      end
    end

    self.class.fields.each do | field|
      field_data = hash[field[:name]]
      if field_data && field[:class] && !field_data.kind_of?(field[:class])
        field_data = field_data.symbolize_keys if field_data.kind_of? Hash
        col_hash[field[:name]] = field[:to].call(field_data)
      end
    end

    hash_new = hash.merge col_hash

    @table = {}
    if hash_new
      hash_new.each_pair do |k, v|
        k = k.to_sym.id2name
        @table[k] = v
      end
    end
  end

  def add_hash(hash)
    hash.each do |key, value|
      k = key.to_sym.id2name
      table[k] = value
    end
  end


  #
  # Used internally to check if the OpenStruct is able to be
  # modified before granting access to the internal Hash table to be modified.
  #
  def modifiable
    begin
      @modifiable = true
    rescue
      raise RuntimeError, "can't modify frozen #{self.class}", caller(3)
    end
    @table
  end
  protected :modifiable


  # Used internally to defined properties on the
  # OpenStruct. It does this by using the metaprogramming function
  # define_singleton_method for both the getter method and the setter method.
  def new_ostruct_member(name)
    name = name.to_sym
    unless respond_to?(name)
      define_singleton_method(name) { get_table_element(name) }
      define_singleton_method("#{name}=") { |x| table[name] = x }
    end
    name
  end

  protected :new_ostruct_member

  def method_missing(mid, *args) # :nodoc:
    mname = mid.id2name
    len = args.length
    if mname.include?('=')
      mname = mname.chomp('=')
      if len != 1
        raise ArgumentError, "wrong number of arguments (#{len} for 1)", caller(1)
      end
      modifiable[mname] = args[0]
    elsif len == 0
      get_table_element(mname)
    else
      err = NoMethodError.new "undefined method `#{mid}' for #{self}", mid, args
      err.set_backtrace caller(1)
      raise err
    end
  end

  def get_table_element(id)
    table[id]
  end

  def table
    @table
  end

  # Returns the value of a member.
  #
  #   person = OpenStruct.new('name' => 'John Smith', 'age' => 70)
  #   person[:age] # => 70, same as ostruct.age
  #
  def [](name)
    @table[name.to_sym]
  end

  #
  # Sets the value of a member.
  #
  #   person = OpenStruct.new('name' => 'John Smith', 'age' => 70)
  #   person[:age] = 42 # => equivalent to ostruct.age = 42
  #   person.age # => 42
  def []=(name, value)
    modifiable[name] = value
  end

  #
  # Remove the named field from the object. Returns the value that the field
  # contained if it was defined.
  #
  #   require 'ostruct'
  #
  #   person = OpenStruct.new('name' => 'John Smith', 'age' => 70)
  #
  #   person.delete_field('name')  # => 'John Smith'
  #
  def delete_field(name)
    sym = name.to_sym
    singleton_class.__send__(:remove_method, sym, "#{sym}=")
    @table.delete sym
  end

  InspectKey = :__inspect_key__ # :nodoc:

  #
  # Returns a string containing a detailed summary of the keys and values.
  #
  # def inspect
  # end
  # alias :to_s :inspect

  attr_reader :table # :nodoc:
  protected :table

  #
  # Compares this object and +other+ for equality.  An OpenStruct is equal to
  # +other+ when +other+ is an OpenStruct and the two objects' Hash tables are
  # equal.
  #
  def ==(other)
    return false unless other.kind_of?(CouchStruct)
    @table == other.table
  end

  #
  # Compares this object and +other+ for equality.  An OpenStruct is eql? to
  # +other+ when +other+ is an OpenStruct and the two objects' Hash tables are
  # eql?.
  #
  def eql?(other)
    return false unless other.kind_of?(CouchStruct)
    @table.eql?(other.table)
  end

  # Compute a hash-code for this OpenStruct.
  # Two hashes with the same content will have the same hash code
  # (and will be eql?).
  def hash
    @table.hash
  end
end
