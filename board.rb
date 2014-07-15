require './pieces.rb'

class Board

  attr_reader :grid

  def initialize
    @grid = generate_grid
  end

  def [](pos)
    x, y = pos
    @grid[x][y]
  end

  def move(start, target)

  end

  def in_check?(color)

  end

  private

  def generate_grid
    grid = Array.new(8) { Array.new(8) { nil } }

    grid[0][0] = Rook.new([0, 0], :black, self)
    grid[0][1] = Knight.new([0, 1], :black, self)
    grid[0][2] = Bishop.new([0, 2], :black, self)
    grid[0][3] = Queen.new([0, 3], :black, self)
    grid[0][4] = King.new([0, 4], :black, self)
    grid[0][5] = Bishop.new([0, 5], :black, self)
    grid[0][6] = Knight.new([0, 6], :black, self)
    grid[0][7] = Rook.new([0, 7], :black, self)

    grid[1][0] = Pawn.new([1, 0], :black, self)
    grid[1][1] = Pawn.new([1, 1], :black, self)
    grid[1][2] = Pawn.new([1, 2], :black, self)
    grid[1][3] = Pawn.new([1, 3], :black, self)
    grid[1][4] = Pawn.new([1, 4], :black, self)
    grid[1][5] = Pawn.new([1, 5], :black, self)
    grid[1][6] = Pawn.new([1, 6], :black, self)
    grid[1][7] = Pawn.new([1, 7], :black, self)

    grid[6][0] = Pawn.new([6, 0], :white, self)
    grid[6][1] = Pawn.new([6, 1], :white, self)
    grid[6][2] = Pawn.new([6, 2], :white, self)
    grid[6][3] = Pawn.new([6, 3], :white, self)
    grid[6][4] = Pawn.new([6, 4], :white, self)
    grid[6][5] = Pawn.new([6, 5], :white, self)
    grid[6][6] = Pawn.new([6, 6], :white, self)
    grid[6][7] = Pawn.new([6, 7], :white, self)

    grid[7][0] = Rook.new([7, 0], :white, self)
    grid[7][1] = Knight.new([7, 1], :white, self)
    grid[7][2] = Bishop.new([7, 2], :white, self)
    grid[7][3] = Queen.new([7, 3], :white, self)
    grid[7][4] = King.new([7, 4], :white, self)
    grid[7][5] = Bishop.new([7, 5], :white, self)
    grid[7][6] = Knight.new([7, 6], :white, self)
    grid[7][7] = Rook.new([7, 7], :white, self)

    grid
  end

end