require_relative "board"
require_relative "player"

class ConnectFour
  def initialize
    @board = Board.new
    @player1 = Player.new("Player 1", "X")
    @player2 = Player.new("Player 2", "O")
    @board.current_player = @player1
  end

  def ask_column
    loop do
      print "#{@board.current_player.name}, choose a column (1 - 7): "
      response = ask_input.to_i - 1
      return response if response.between?(0, 6)

      puts "Invalid entry, try again."
    end
  end

  def play
    loop do
      @board.display_board
      @board.drop_token?(ask_column, @board.current_player.token)

      if game_over?
        @board.display_board
        return announce_winner
      end

      switch_player
    end
  end

  private

  def ask_input
    gets.chomp
  end

  def game_over?
    @board.winner?(@board.current_player.token) || @board.board_full?
  end

  def announce_winner
    if @board.winner?(@board.current_player.token)
      puts "#{@board.current_player.name} won the game"
    else
      puts "Board is full, its a draw game"
    end
  end

  def switch_player
    @board.current_player = (@board.current_player == @player1 ? @player2 : @player1)
  end
end
