require_relative "../lib/game"
require "tmpdir"

describe ConnectFour do
  around do |example|
    Dir.mktmpdir("connect-four-spec") do |directory|
      @save_store = GameSave.new(path: File.join(directory, "saved_game.json"))
      example.run
    end
  end

  let(:console) { instance_double(Console) }
  let(:board) { Board.new }
  let(:computer_player) { instance_double(ComputerPlayer) }
  subject(:game) { described_class.new }

  before do
    allow(Board).to receive(:new).and_return(board)
    allow(Console).to receive(:new).and_return(console)
    allow(GameSave).to receive(:new).and_return(@save_store)
    allow(console).to receive(:ask_game_mode).and_return(:two_players)
    allow(board).to receive(:display_board)
  end

  it "initializes without constructor arguments" do
    expect(described_class.instance_method(:initialize).arity).to eq(0)
  end

  describe "#play" do
    it "announces the winner when a player gets four in a row" do
      allow(console).to receive(:ask_column).and_return(0, 6, 1, 6, 2, 5, 3)
      expect(console).to receive(:announce_winner).with(an_instance_of(Player))

      game.play
    end

    it "saves the board and current player when quitting" do
      allow(console).to receive(:ask_column).and_return(0, 1, :quit)
      expect(console).to receive(:announce_saved_game)

      game.play

      expect(@save_store.exists?).to be true
      expect(@save_store.load.fetch("board").flatten).to include("X", "O")
      expect(@save_store.load.fetch("current_player")).to eq("X")
    end

    it "uses the computer as Player 2 and saves the selected mode" do
      allow(ComputerPlayer).to receive(:new).and_return(computer_player)
      allow(console).to receive(:ask_game_mode).and_return(:computer)
      allow(console).to receive(:ask_column).with("Player 1").and_return(0, :quit)
      allow(computer_player).to receive(:choose_column).and_return(3)
      expect(console).to receive(:announce_computer_move).with(4)
      allow(console).to receive(:announce_saved_game)

      game.play

      expect(@save_store.load.fetch("mode")).to eq("computer")
      expect(@save_store.load.fetch("board").flatten).to include("X", "O")
    end

    it "resumes computer mode when the computer was next to play" do
      allow(ComputerPlayer).to receive(:new).and_return(computer_player)
      @save_store.save(
        board: board,
        current_player: Player.new("Computer", "O"),
        mode: :computer
      )
      allow(console).to receive(:ask_resume_choice).and_return(:continue)
      allow(computer_player).to receive(:choose_column).and_return(3)
      allow(console).to receive(:ask_column).with("Player 1").and_return(:quit)
      allow(console).to receive(:announce_saved_game)
      expect(console).to receive(:announce_computer_move).with(4)

      game.play

      expect(@save_store.load.fetch("mode")).to eq("computer")
    end

    it "keeps the same player when their chosen column is full" do
      grid = Array.new(Board::ROWS) { Array.new(Board::COLUMNS, Board::EMPTY_SLOT) }
      Board::ROWS.times { |row| grid[row][0] = row.even? ? "X" : "O" }
      board.load_grid(grid)
      expect(console).to receive(:ask_column).with("Player 1").ordered.and_return(0)
      expect(console).to receive(:ask_column).with("Player 1").ordered.and_return(1)
      expect(console).to receive(:ask_column).with("Player 2").ordered.and_return(:quit)
      expect(console).to receive(:announce_full_column)
      allow(console).to receive(:announce_saved_game)

      game.play
    end

    it "restores the saved board and current player" do
      allow(console).to receive(:ask_column).and_return(0, 1, :quit)
      allow(console).to receive(:announce_saved_game)
      game.play
      allow(console).to receive(:ask_resume_choice).and_return(:continue)
      allow(console).to receive(:ask_column).and_return(:quit)
      expect(console).to receive(:ask_column).with("Player 1").and_return(:quit)
      allow(console).to receive(:announce_saved_game)
      expect(@save_store).to receive(:load).and_call_original

      described_class.new.play
    end

    it "deletes a saved game when starting a new game" do
      @save_store.save(board: board, current_player: Player.new("Player 1", "X"))
      allow(console).to receive(:ask_resume_choice).and_return(:new)
      allow(console).to receive(:ask_column).and_return(:quit)
      allow(console).to receive(:announce_saved_game)
      expect(@save_store).to receive(:delete).ordered.and_call_original
      expect(@save_store).to receive(:save).ordered.and_call_original

      game.play

      expect(@save_store.exists?).to be true
    end
  end
end
