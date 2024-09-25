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
end
