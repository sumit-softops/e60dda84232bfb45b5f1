class Api::SudokuController < ApplicationController

  def create
    unsolved_sudoku_data = params[:data]
    unsolved_sudoku_data = unsolved_sudoku_data.map {|e| e.map {|f| f == 'null' ? nil : f}}
    solved_sudoku_data = SudokuDataSolveService.new(unsolved_sudoku_data).solution
    render json: { solution: solved_sudoku_data }
  end

end
