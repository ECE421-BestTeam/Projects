require 'Matrix'
require './sparse_hash.rb'

class SparseMatrix < Matrix 

#  +
#  -
#  *
#  /
#  determinant
#  inverse
#  transpose
#  zero    

  attr_accessor :rows
  attr_accessor :column_count
  attr_accessor :row_count
  
  def rows(rows)
    @column_count = rows[0].length
    # populate the hash!
    @rows = new SparseHash(rows.length)
    rows.each_with_index do |row, rowNum|
      @rows[rowNum] = new SparseHash(row.length)
      row.each_with_index do |val, colNum|
        @rows.set(rowNum, colNum, val)
      end
    end
  end
  
  # Is just (matrix * thing.inverse) so it should be faster just by using our inverse+determinant functions
#  def /(thing)
#    
#  end
  
  def inverse
    det = determinant
    Matrix.Raise ErrNotRegular if det == 0
    
    a = @rows  #Make a deep copy!

  end
  
  def inverse0
    det = determinant
    Matrix.Raise ErrNotRegular if det == 0
    
    a = @rows  #Make a deep copy!

    (0..(@column_count - 1)).each do |k|
      i = k
      akk = a[k, k].abs
      ((k + 1)..(@column_count - 1)).each do |j|
        v = a[j, k].abs
        if v > akk
          i = j
          akk = v
        end
      end
      Matrix.Raise ErrNotRegular if akk == 0
      if i != k
        a[i], a[k] = a[k], a[i]
        @rows[i], @rows[k] = @rows[k], @rows[i]
      end
      akk = a[k, k]

      (0..(@column_count - 1)).each do |ii|
        next if ii == k
        q = a[ii, k].quo(akk)
        a[ii, k] = 0

        (k + 1).upto(last) do |j|
          a[ii, j] -= a[k, j] * q
        end
        (0..(@column_count - 1)).each do |j|
          @rows[ii][j] -= @rows[k][j] * q
        end
      end

      ((k + 1)..(@column_count - 1)).each do |j|
        a[k][j] = a[k][j].quo(akk)
      end
      (0..(@column_count - 1)).each do |j|
        @rows[k][j] = @rows[k][j].quo(akk)
      end
    end
  end
  
  def determinant()
    if (@column_count != @row_count)
      SparseMatrix.Raise ErrDimensionMismatch
    end
    
    return innerDeterminant(-1, @column_count, (0..@column_count - 1))
  end
  
  # x, y - the coords of the previous coefficient
  # cols - data about the cols being considered (or the range [inclusive] to consider)
  private
  def innerDeterminant(x, y, cols)
    # create the new cols
    newCols = {}
    if (cols.class == Range) 
      # We need to create a fresh newCols
      cols.each do |colNum|
        if (colNum < y)
          if (colNum % 2 == 0)
            newCols[colNum] = :+
          else
            newCols[colNum] = :-
          end
        elsif (colNum > y)
          if (colNum % 2 == 0)
            newCols[colNum] = :-
          else
            newCols[colNum] = :+
          end
        end
      end        
    else
      # We need to modify newCols from existing cols
      cols.each_sparse do |entry|
        colNum = entry[0]
        op = entry[1]
        if (colNum < y)
          newCols[colNum] = op
        elsif (colNum > y)
            if (op == :+)
              newCols[colNum] = :-
            else
              newCols[colNum] = :+
            end
        end
      end  
    end
    
    x += 1 # new coefficient will be on this row
    
    if (newCols.length == 1) # we have reached the lowest level
      newCols.each_sparse do |entry|
        colNum = entry[0] 
        return @rows[x][colNum]
      end
    end
    
    result = 0
    newCols.each_sparse do |entry|
      colNum = entry[0]
      op = entry[1]
      temp = @rows[x][colNum] * innerDeterminant(x, colNum, newCols)
      if (op == :+)
        result += temp
      else
        result -= temp
      end
    end
    return result
  end

end