# frozen_string_literal: true

require 'bitmap_manager'

RSpec.describe BitmapManager do
  let(:bitmap_manager) { described_class.new }

  describe 'new_image' do
    it 'instantiates a new current_image of the given proportions' do
      bitmap_manager.new_image(4, 3)
      expect(bitmap_manager.show_image).to eq(
        <<~PIXELS
          OOOO
          OOOO
          OOOO
        PIXELS
      )
    end
  end

  describe 'show_image' do
    subject { bitmap_manager.show_image }

    context 'when no current_image (by default)' do
      it { is_expected.to eq '' }
    end

    context 'when current_image is set' do
      before do
        bitmap_manager.new_image(3, 4)
      end

      it 'returns the to_s representation of the current_image' do
        expect(subject).to eq(
          <<~PIXELS
            OOO
            OOO
            OOO
            OOO
          PIXELS
        )
      end
    end
  end

end
