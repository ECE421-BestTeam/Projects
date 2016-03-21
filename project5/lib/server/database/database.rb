require_relative './contract-database'
require_relative './database-local'

class Database
  include DatabaseContract
  
  def initialize(type = :databaseLocal)
    case type
      when :databaseLocal
        @implementation = DatabaseLocal.new
    end
  end
  
  # returns all entries as an array of hashes
  def getAll(table)
    pre_getAll(table)
    
    result = @implementation.getAll(table)
    
    post_getAll(result)
    class_invariant
    return result
  end
  
  # returns entry (hash)
  def get(table, id)
    pre_get(table, id)
    
    result = @implementation.get(table, id)
    
    post_get(result)
    class_invariant
    return result
  end
  
  # adds an entry
  # returns the id
  def add(table, newEntry)
    pre_add(table, newEntry)
    
    result = @implementation.add(table, newEntry)
    
    post_add(result)
    class_invariant
    return result
  end
  
  # updates an entry
  # returns id
  def update(table, updatedEntry)
    pre_update(table, updatedEntry)
    
    result = @implementation.update(table, updatedEntry)
    
    post_update(result)
    class_invariant
    return result
  end
  
  # deletes an entry by id
  # returns true on success
  def delete(table, id)
    pre_delete(table, id)
    
    result = @implementation.delete(table, id)
    
    post_delete(result)
    class_invariant
    return result
  end
  
end

puts Database.new(:databaseLocal).getAll(:checkedOutGames)