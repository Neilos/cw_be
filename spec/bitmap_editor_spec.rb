# frozen_string_literal: true

require 'bitmap_editor'

RSpec.describe BitmapEditor do
  let(:bitmap_editor) { described_class.new }

  describe 'run' do
    context 'when a command is unrecognised' do
      let(:file_path) { 'spec/fixtures/invalid_command.txt' }

      it 'yields warning to given block but executes other commands' do
        expect { |blk|
          bitmap_editor.run(file_path, &blk)
        }.to yield_successive_args(
          nil,
          'unrecognised command :(',
          <<~PIXELS
            OOOOO
            OOOOO
            OOOOO
            OOOOO
            OOOOO
            OOOOO
          PIXELS
        )
      end
    end

    context 'when image transformation command is before image creation' do
      let(:file_path) { 'spec/fixtures/no_image.txt' }

      it 'yields warning to given block but executes other commands' do
        expect { |blk|
          bitmap_editor.run(file_path, &blk)
        }.to yield_successive_args(
          'There is no image',
          nil,
          nil,
          <<~PIXELS
            OOOOO
            OOOOO
            OOOBO
            OOOBO
            OOOBO
            OOOOO
          PIXELS
        )
      end
    end

    context 'when command file is valid' do
      let(:file_path) { 'spec/fixtures/valid.txt' }

      it 'executes commands correctly' do
        expect { |blk|
          bitmap_editor.run(file_path, &blk)
        }.to yield_successive_args(
          nil,
          nil,
          nil,
          nil,
          <<~PIXELS
            OOOOO
            OOZZZ
            AWOOO
            OWOOO
            OWOOO
            OWOOO
          PIXELS
        )
      end
    end
  end
end
