require "json"

class GameSave
  DEFAULT_PATH = File.expand_path("~/.connect_four_save.json")

  def initialize(path: DEFAULT_PATH)
    @path = path
  end

  def exists?
    File.exist?(@path)
  end

  def save(board:, current_player:)
    state = {
      board: board.to_a,
      current_player: current_player.token
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
