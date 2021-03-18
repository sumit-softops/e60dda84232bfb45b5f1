class SudokuDataSolveService
  def initialize(sudoku)
    raise TypeError, "Sudoku should be initialized with an Array" if sudoku.class != Array
    raise StandardError, "Given Size is not proper" if sudoku.map { |a| a.size }.uniq != [9]
    
    @sudoku = {}
    j = 0
    sudoku.each do |row|
      9.times do |i|
        if i <= 2 && j <= 2
          b = 0
        elsif i <= 5 && j <= 2
          b = 1
        elsif i > 5 && j <= 2
          b = 2
        elsif i <= 2 && j <= 5
          b = 3
        elsif i <= 5 && j <= 5
          b = 4
        elsif i > 5 && j <= 5
          b = 5
        elsif i <= 2 && j > 5
          b = 6
        elsif i <= 5 && j > 5
          b = 7
        else
          b =8
        end
        @sudoku[i.to_s + j.to_s + b.to_s] = row[i]
      end
      j += 1
    end
  end
  
  def to_s
    @sudoku.values.each_slice(9).to_a.to_s
  end

  def solution
    unsolved_sudoku = {}
    @keysizes = []
    @sudoku.each do |key, value|
      if value.nil?
        unsolved_sudoku[key] = [1,2,3,4,5,6,7,8,9]
      end
    end

    until sudoku_solved
      unsolved_sudoku.each do |key, value|
        value.reject! do |number|
          (@sudoku.row(key[1].to_i) + @sudoku.column(key[0].to_i) + @sudoku.box(key[2].to_i)).include?(number)
        end
        @sudoku[key] = value[0] if value.size == 1
        unsolved_sudoku.delete_if { |key, value| value.empty? }
      end

      unsolved_sudoku.each do |key, value|
        if unsolved_sudoku.row(key[1].to_i).has_naked_multiple?(value)
          unsolved_sudoku.each do | nkey, nvalue |
            nvalue.reject! { | n | value.include?(n)} if (!(nvalue-value).empty? && key[1] == nkey[1]) 
          end
        end
        if unsolved_sudoku.column(key[0].to_i).has_naked_multiple?(value)
          unsolved_sudoku.each do | nkey, nvalue |
            nvalue.reject! { | n | value.include?(n)} if (!(nvalue-value).empty? && key[0] == nkey[0]) 
          end
        end
        if unsolved_sudoku.box(key[2].to_i).has_naked_multiple?(value)
          unsolved_sudoku.each do | nkey, nvalue |
            nvalue.reject! { | n | value.include?(n)} if (!(nvalue-value).empty? && key[2] == nkey[2]) 
          end
        end

        @sudoku[key] = value[0] if value.size == 1
        unsolved_sudoku.delete_if { | key, value | value.empty? }
      end

      if unsolvable_sudoku
        puts "Sudoku is Impossible to solve. Best solution is (n if no solution) : "
        @sudoku.to_s
        break
      end
    end
    
    return @sudoku.values.each_slice(9).to_a

  end

  private

    def sudoku_solved
      @sudoku.values.compact.size == 81
    end

    def unsolvable_sudoku
      @keysizes << @sudoku.values.compact.size
      @keysizes[-1] == @keysizes[-3]
    end
end