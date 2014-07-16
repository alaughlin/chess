#!/usr/bin/env ruby
require_relative 'board.rb'

class InvalidInputError < ArgumentError
end

class Chess
  COLS = {
    "a" => 0,
    "b" => 1,
    "c" => 2,
    "d" => 3,
    "e" => 4,
    "f" => 5,
    "g" => 6,
    "h" => 7
  }

  ROWS = {
    "1" => 7,
    "2" => 6,
    "3" => 5,
    "4" => 4,
    "5" => 3,
    "6" => 2,
    "7" => 1,
    "8" => 0
  }

  def initialize
    @board = Board.new
    @turn = :white
  end

  def play
    until @board.checkmate?(:black) || @board.checkmate?(:white)
      puts "\n#{@turn.to_s.capitalize}'s turn.\n\n"

      if @board.in_check?(:black)
        puts "Black player is in check!"
      elsif @board.in_check?(:white)
        puts "White player is in check!"
      end

      @board.display

      begin
        coords = get_input
        @board.move_piece(coords[0], coords[1], @turn)
      rescue MissingPieceError
        puts "No piece at start position!"
        retry
      rescue WrongColorError
        puts "You can't move an opponent's piece!"
        retry
      rescue InvalidMoveError
        puts "I can't let you do that, Star Fox!"
        retry
      end

      @turn == :white ? @turn = :black : @turn = :white
    end

    winner = @board.checkmate?(:black) ? :white : :black
    @board.display
    puts "#{winner.to_s.capitalize} wins!"
  end

  def get_input
     # takes input as two sets of two letters each.
    print "\n#{@turn.to_s.capitalize} player: input your move. (e.g. A2, A4): "
    begin
      input = gets.chomp.downcase.gsub(" ", "").split(',')
      input.each do |pair|
        raise InvalidInputError unless COLS.keys.include?(pair[0])
        raise InvalidInputError unless ROWS.keys.include?(pair[1])
      end
    rescue InvalidInputError
      puts "Invalid coordinates. Try again!"
      retry
    end

    first_pair = [ROWS[input[0][1]], COLS[input[0][0]]]
    second_pair = [ROWS[input[1][1]], COLS[input[1][0]]]

    [first_pair, second_pair]
  end
end

if __FILE__ == $PROGRAM_NAME
  g = Chess.new
  g.play
end