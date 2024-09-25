require_relative '../lib/player'

describe Player do
  describe '#ask_column' do
    subject(:player) { described_class.new('Alice', 'x') }

    context 'when user enters a valid input' do
      before do
        valid_input = '4'
        allow(player).to receive(:print)
        allow(player).to receive(:gets).and_return(valid_input)
      end

      it 'return valid input minus 1' do
        expect(player.ask_column).to eq(3)
      end
    end

    context 'when user enters an invalid input then a valid input' do
      before do
        letter = 'q'
        valid_input = '5'
        allow(player).to receive(:print)
        allow(player).to receive(:gets).and_return(letter, valid_input)
      end

      it 'returns error message once' do
        error_message = 'Invalid entry, try again.'
        expect(player).to receive(:puts).with(error_message).once
        player.ask_column
      end
    end
  end
end
