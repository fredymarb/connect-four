require_relative '../lib/board'

describe Board do
  subject(:board) { described_class.new }

  describe '#drop_token' do
    context 'when column is empty' do
      let(:grid) { board.instance_variable_get(:@grid) }
      let(:token) { board.instance_variable_get(:@current_player).token }

      it 'drops token at the lowest row' do
        board.drop_token(0)
        expect(grid[5][0]).to eq(token)
      end

      it 'returns true' do
        expect(board.drop_token(0)).to eq true
      end
    end

    context 'when column is partially full' do
      let(:grid) { board.instance_variable_get(:@grid) }
      let(:token) { board.instance_variable_get(:@current_player).token }

      it 'drops token in the next available column' do
        board.drop_token(0) # drop token at the bottom row
        board.drop_token(0) # drop again at the same column

        expect(grid[4][0]).to eq(token)
      end
    end

    context 'when column is full' do
      it 'does not drop token and returns false' do
        6.times { board.drop_token(0) } # Fill the entire column with tokens
        expect(board.drop_token(0)).to be false
      end
    end
  end

  describe '#switch_player' do
    it 'switches current player from player1 to player2' do
      current_player = board.instance_variable_get(:@current_player)
      expect(current_player).to eq(board.instance_variable_get(:@player1))

      board.switch_player
      expect(board.instance_variable_get(:@current_player)).to eq(board.instance_variable_get(:@player2))
    end

    it 'switches the current player back to player1' do
      # Switch twice to go back to player1
      board.switch_player
      board.switch_player
      expect(board.instance_variable_get(:@current_player)).to eq(board.instance_variable_get(:@player1))
    end
  end

  describe '#board_full?' do
    context 'when board if full' do
      before do
        # fill the entire board to the max
        6.times { board.drop_token(0) }
        6.times { board.drop_token(1) }
        6.times { board.drop_token(2) }
        6.times { board.drop_token(3) }
        6.times { board.drop_token(4) }
        6.times { board.drop_token(5) }
        6.times { board.drop_token(6) }
      end

      it 'returns true' do
        expect(board.board_full?).to be true
      end
    end

    context 'when board is only partially filled' do
      before do
        6.times { board.drop_token(0) }
        6.times { board.drop_token(1) }
        6.times { board.drop_token(2) }
      end

      it 'returns false' do
        expect(board.board_full?).to be false
      end
    end

    context 'when board is empty' do
      it 'returns false' do
        expect(board.board_full?).to be false
      end
    end
  end

  describe '#winner?' do
    context 'when horizontal win occurs' do
      before do
        board.drop_token(0)
        board.drop_token(1)
        board.drop_token(2)
        board.drop_token(3)
      end

      it 'returns true' do
        expect(board.winner?).to be true
      end
    end

    context 'when vertical win occurs' do
      before do
        4.times { board.drop_token(0) }
      end

      it 'returns true' do
        expect(board.winner?).to be true
      end
    end

    context 'when diagonal win occurs' do
      before do
        board.drop_token(0) # Player 1

        board.drop_token(1) # Player 1
        board.drop_token(1) # Player 1

        board.drop_token(2) # Player 1
        board.drop_token(2) # Player 1
        board.drop_token(2) # Player 1

        board.switch_player
        board.drop_token(3) # Player 2
        board.drop_token(3) # Player 2
        board.drop_token(3) # Player 2

        board.switch_player
        board.drop_token(3) # Player 1 (this completes the diagonal win)
      end

      it 'returns true' do
        expect(board.winner?).to be true
      end
    end

    context 'when there isnt a winner' do
      before do
        3.times { board.drop_token(0) }
      end

      it 'returns false' do
        expect(board.winner?).to be false
      end
    end
  end
end
