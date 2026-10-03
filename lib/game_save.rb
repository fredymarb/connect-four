require "json"

class GameSave
  DEFAULT_PATH = File.expand_path("../.connect_four_save.json", __dir__)

  def initialize(path: DEFAULT_PATH)
    @path = path
  end

  def exists?
    File.exist?(@path)
  end

  def save(board:, current_player:, mode: :two_players)
    state = {
      board: board.to_a,
      current_player: current_player.token,
      mode: mode.to_s
    }
    File.write(@path, JSON.pretty_generate(state))
  end

  def load
    JSON.parse(File.read(@path))
  end

  def delete
    File.delete(@path) if exists?
  end
end
