require 'byebug'

class World
  attr_reader :grid

  def initialize(rows, columns)
    @rows = rows
    @columns = columns
    @grid = Array.new(@columns) do
      Array.new(@rows)
    end
  end

  def make_alive(row, column)
      @grid[row][column] = "X"
  end

  def make_dead(row, column)
    @grid[row][column] = " "
  end

  def alive?(row, column)
    if @grid[row][column] == "X"
      return true
    else
      return false
    end
  end

  def amount_of_neighbours(row, column)
    neighbours = 0
      if column < @columns && alive?(row, column + 1)
        neighbours = neighbours + 1
      end
      if alive?(row, column - 1) && column > 0
        neighbours = neighbours + 1
      end
      if row < @rows && alive?(row + 1, column)
        neighbours = neighbours + 1
      end
      if row > 0 && alive?(row - 1, column)
        neighbours = neighbours + 1
      end
      if column < @columns && row < @rows && alive?(row + 1, column + 1)
        neighbours = neighbours + 1
      end
      if column > 0 && row > 0 && alive?(row - 1, column - 1)
        neighbours = neighbours + 1
      end
      if column < @columns && row > 0 && alive?(row - 1, column + 1)
        neighbours = neighbours + 1
      end
      if column > 0 && row < @rows && alive?(row + 1, column - 1)
        neighbours = neighbours + 1
      end
    return neighbours
  end

  def next_generation
    row = 0
    make_alive_coordinates = []
    make_dead_coordinates = []
    while row < @rows
      column = 0
      while column < @columns
            neighbours = amount_of_neighbours(row, column)
        if !alive?(row, column) && neighbours == 3
          make_alive_coordinates << [row, column]
        end
        if alive?(row, column) && neighbours != 2  && neighbours != 3
          make_dead_coordinates << [row, column]
        end
        column = column + 1
      end
      row = row + 1
    end
    make_alive_coordinates.each do |c|
      make_alive(c[0], c[1])
    end
    make_dead_coordinates.each do |o|
      make_dead(o[0], o[1])
    end
  end
end
