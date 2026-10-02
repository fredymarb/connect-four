require_relative "board"
require_relative "player"

class ConnectFour
  def initialize
    @board = Board.new
    @player1 = Player.new("Player 1", "X")
    @player2 = Player.new("Player 2", "O")
    @board.current_player = @player1
  end

  def play
    loop do
      @board.display_board
      @board.drop_token?(@board.current_player.ask_column, @board.current_player.token)

      if game_over?
        @board.display_board
        return announce_winner
      end

      switch_player
    end
  end

  private

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
