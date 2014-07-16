require './pieces.rb'

class MissingPieceError < RuntimeError
end

class InvalidMoveError < RuntimeError
end

class Board

  attr_reader :grid

  def initialize(grid = nil)
    @grid = grid.nil? ? generate_grid : grid
  end

  def [](pos)
    x, y = pos
    @grid[x][y]
  end

  def []=(pos, object)
    x, y = pos
    @grid[x][y] = object
  end

  def move(start, target) # gets valid coords from game
    begin
      raise MissingPieceError if self[start].nil?
      raise InvalidMoveError unless self[start].valid_moves.include?(target)
    rescue MissingPieceError
      puts "No piece at start position!"
    rescue InvalidMoveError
      puts "Can't move there!"
    end

    self[start].move(target)
  end

  def in_check?(color)
    pieces = grid.flatten.compact

    king = pieces.find { |piece| piece.color == color && piece.is_a?(King) }
    king_pos = king.position

    enemy_pieces = pieces.select { |piece| piece.color != color }

    enemy_pieces.any? { |piece| piece.valid_move?(king_pos, self) }
  end

  def checkmate?(color)
    pieces = grid.flatten.compact
    our_pieces = pieces.select { |piece| piece.color == color }

    in_check?(color) && our_pieces.none? { |piece| piece.valid_moves.count > 0 }
  end

  def dup
    new_grid = @grid.map do |row|
      row.map do |piece|
        piece.nil? ? nil : piece.dup
      end
    end

    Board.new(new_grid)
  end

  def display
    puts "  A B C D E F G H"
    @grid.each_with_index do |row, i|
      print "#{8 - i} "
      row.each do |piece|
        print piece.nil? ? "_ " : piece.render + " "
      end

      puts ""
    end

    nil
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