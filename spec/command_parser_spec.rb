# frozen_string_literal: true

require 'command_parser'

RSpec.describe CommandParser do
  let(:command_parser) { described_class.new }

  describe '#parse' do
    context 'when command is I' do
      it 'returns the appropriate command_method and args' do
        expect(command_parser.parse('I 4 5')).to eq(
          [:new_image, 4, 5]
        )
      end
    end

    context 'when command is C' do
      it 'returns the appropriate command_method and args' do
        expect(command_parser.parse('C')).to eq(
          [:clear_image]
        )
      end
    end

    context 'when command is L' do
      it 'returns the appropriate command_method and args' do
        expect(command_parser.parse('L 6 4 D')).to eq(
          [:draw_single_pixel, 6, 4, 'D']
        )
      end
    end

    context 'when command is V' do
      it 'returns the appropriate command_method and args' do
        expect(command_parser.parse('V 2 5 4 D')).to eq(
          [:draw_vertical_line, 2, 5, 4, 'D']
        )
      end
    end

    context 'when command is H' do
      it 'returns the appropriate command_method and args' do
        expect(command_parser.parse('H 2 5 4 D')).to eq(
          [:draw_horizontal_line, 2, 5, 4, 'D']
        )
      end
    end

    context 'when command is H' do
      it 'returns the appropriate command_method and args' do
        expect(command_parser.parse('S')).to eq(
          [:show_image]
        )
      end
    end

    context 'when command is unrecognized' do
      it 'raises a CommandParser::UnrecognizedError' do
        expect { command_parser.parse('WORD') }.to raise_error(
          CommandParser::UnrecognizedError
        )
      end
    end
  end
end
