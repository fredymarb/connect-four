require_relative 'board'

class ConnectFour
  def initialize
    @board = Board.new
  end

  def play
    loop do
      display_board
      response = ask_column
      drop_token(response)

      if game_over?
        display_board
        return announce_winner
      end

      switch_player
    end
  end

  private

  def display_board
    @board.display_board
  end

  def ask_column
    @board.current_player.ask_column
  end

  def drop_token(col)
    @board.drop_token(col)
  end

  def game_over?
    @board.winner? || @board.board_full?
  end

  def announce_winner
    if @board.winner?
      puts "#{@board.current_player.name} won the game"
    else
      puts 'Board is full, its a draw game'
    end
  end

  def switch_player
    @board.switch_player
  end
end
