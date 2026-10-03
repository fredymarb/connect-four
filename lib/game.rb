require_relative "board"
require_relative "computer_player"
require_relative "console"
require_relative "game_save"
require_relative "player"

class ConnectFour
  def initialize
    @board = Board.new
    @console = Console.new
    @save_store = GameSave.new
    @computer_player = ComputerPlayer.new
    @mode = :two_players
    @players = default_players
    @current_player = @players.first
  end

  def play
    prepare_game
    loop do
      @board.display_board
      result = play_turn
      return if result == :quit
      next if result == :retry

      return finish_game if game_over?

      switch_player
    end
  end

  private

  def play_turn
    return play_computer_turn if computer_turn?

    column = @console.ask_column(@current_player.name)
    return save_and_quit if column == :quit
    return retry_turn unless @board.drop_token?(column, @current_player.token)

    :played
  end

  def play_computer_turn
    column = @computer_player.choose_column(
      @board,
      @current_player.token,
      opponent_token
    )
    @console.announce_computer_move(column + 1)
    @board.drop_token?(column, @current_player.token)
    :played
  end

  def save_and_quit
    @save_store.save(board: @board, current_player: @current_player, mode: @mode)
    @console.announce_saved_game
    :quit
  end

  def retry_turn
    @console.announce_full_column
    :retry
  end

  def finish_game
    @board.display_board
    announce_result
    @save_store.delete
  end

  def announce_result
    return @console.announce_winner(@current_player) if @board.winner?(@current_player.token)

    @console.announce_draw
  end

  def game_over?
    @board.winner?(@current_player.token) || @board.board_full?
  end

  def switch_player
    current_index = @players.index(@current_player)
    @current_player = @players[(current_index + 1) % @players.length]
  end

  def restore_saved_game
    saved_game = @save_store.load
    @mode = saved_game.fetch("mode", "two_players").to_sym
    @players = default_players
    @board.load_grid(saved_game.fetch("board"))
    @current_player = find_player(saved_game.fetch("current_player"))
  end

  def prepare_game
    if @save_store.exists?
      return restore_saved_game if @console.ask_resume_choice == :continue

      @save_store.delete
    end

    @mode = @console.ask_game_mode
    @players = default_players
    @current_player = @players.first
  end

  def find_player(token)
    @players.find { |player| player.token == token } ||
      raise(ArgumentError, "Invalid saved current player")
  end

  def computer_turn?
    @mode == :computer && @current_player.token == "O"
  end

  def opponent_token
    @players.find { |player| player != @current_player }.token
  end

  def default_players
    second_player = @mode == :computer ? Player.new("Computer", "O") : Player.new("Player 2", "O")
    [ Player.new("Player 1", "X"), second_player ]
  end
end
