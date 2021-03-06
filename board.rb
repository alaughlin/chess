Dir["./pieces/*.rb"].each {|file| require file }
require 'colorize'

class MissingPieceError < RuntimeError
end

class InvalidMoveError < RuntimeError
end

class WrongColorError < RuntimeError
end

class Board

  attr_reader :grid

  def initialize(grid = nil)
    @grid = grid.nil? ? generate_grid : grid
    @captured_blacks = []
    @captured_whites = []
  end

  def [](pos)
    x, y = pos
    @grid[x][y]
  end

  def []=(pos, object)
    x, y = pos
    @grid[x][y] = object
  end

  def move_piece(start, target, turn) # gets valid coords from game
    raise MissingPieceError if self[start].nil?
    raise InvalidMoveError unless self[start].valid_move?(target, self)
    raise WrongColorError if self[start].color != turn

    capture_piece(target) unless self[target].nil?

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
    in_check?(color) && no_legal_moves?(color)
  end

  def stalemate?
    [:white, :black].any? { |color| !in_check?(color) && no_legal_moves?(color)}
  end

  def no_legal_moves?(color)
    pieces = grid.flatten.compact
    our_pieces = pieces.select { |piece| piece.color == color }

    our_pieces.none? { |piece| piece.valid_moves.count > 0 }
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
    puts "   A  B  C  D  E  F  G  H"

    @grid.each_with_index do |row, x|
      print "#{8 - x} "
      row.each_with_index do |piece, y|
        if piece.nil?
          print color_square(x, y, "   ")
        else
          print color_square(x, y, " #{piece.render} ")
        end
      end

      if x == 0
        print "   " + @captured_whites.map { |piece| piece.render }.join(" ")
      elsif x == 7
        print "   " + @captured_blacks.map { |piece| piece.render }.join(" ")
      end

      puts ""
    end
  end

  def blank_grid_test
    @grid = Array.new(8) { Array.new(8) { nil } }
  end

  private

  def capture_piece(target)
    @captured_blacks << self[target] if self[target].color == :black
    @captured_whites << self[target] if self[target].color == :white
  end

  def color_square(row, col, string)
    if (row.even? && col.odd?) || (row.odd? && col.even?)
      string.colorize(:background => :cyan)
    else
      string.colorize(:background => :light_cyan)
    end
  end

  def generate_grid
    piece_pos = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]
    grid = Array.new(8) { Array.new(8) { nil } }

    0.upto(7) do |y|
      grid[0][y] = piece_pos[y].new([0, y], :black, self)
    end

    0.upto(7) do |y|
      grid[1][y] = Pawn.new([1, y], :black, self)
    end

    0.upto(7) do |y|
      grid[6][y] = Pawn.new([6, y], :white, self)
    end

    0.upto(7) do |y|
      grid[7][y] = piece_pos[y].new([7, y], :white, self)
    end

    grid
  end
end