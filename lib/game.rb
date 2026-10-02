require_relative "board"
require_relative "console"
require_relative "game_save"
require_relative "player"

class ConnectFour
  def initialize
    @board = Board.new
    @players = default_players
    @console = Console.new
    @save_store = GameSave.new
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

  def default_players
    [ Player.new("Player 1", "X"), Player.new("Player 2", "O") ]
  end

  def play_turn
    column = @console.ask_column(@current_player.name)
    return save_and_quit if column == :quit
    return retry_turn unless @board.drop_token?(column, @current_player.token)

    :played
  end

  def save_and_quit
    @save_store.save(board: @board, current_player: @current_player)
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
    @board.load_grid(saved_game.fetch("board"))
    @current_player = find_player(saved_game.fetch("current_player"))
  end

  def prepare_game
    return unless @save_store.exists?
    return restore_saved_game if @console.ask_resume_choice == :continue

    @save_store.delete
  end

  def find_player(token)
    @players.find { |player| player.token == token } ||
      raise(ArgumentError, "Invalid saved current player")
  end
end
