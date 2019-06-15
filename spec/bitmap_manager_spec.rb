# frozen_string_literal: true

require 'bitmap_manager'

RSpec.describe BitmapManager do
  let(:bitmap_manager) { described_class.new }

  describe 'draw_single_pixel' do
    before do
      bitmap_manager.new_image(4, 4)
    end

    context 'when position is outside of image bounds' do
      it 'has no effect on the current_image' do
        expect {
          bitmap_manager.draw_single_pixel(2, 5, 'B')
        }.not_to change { bitmap_manager.show_image }
      end
    end

    context 'when position is within image bounds' do
      it 'sets a specified pixel of the current_image to the given color' do
        expect {
          bitmap_manager.draw_single_pixel(2, 3, 'B')
        }.to change {
          bitmap_manager.show_image
        }.from(
          <<~PIXELS
            OOOO
            OOOO
            OOOO
            OOOO
          PIXELS
        ).to(
          <<~PIXELS
            OOOO
            OOOO
            OBOO
            OOOO
          PIXELS
        )
      end
    end
  end

  describe 'draw_vertical_line' do
    before do
      bitmap_manager.new_image(5, 6)
    end

    context 'when line is fully within image bounds' do
      it 'sets appropriate pixels to the given color' do
        expect {
          bitmap_manager.draw_vertical_line(2, 3, 6, 'W')
        }.to change {
          bitmap_manager.show_image
        }.from(
          <<~PIXELS
            OOOOO
            OOOOO
            OOOOO
            OOOOO
            OOOOO
            OOOOO
          PIXELS
        ).to(
          <<~PIXELS
            OOOOO
            OOOOO
            OWOOO
            OWOOO
            OWOOO
            OWOOO
          PIXELS
        )
      end
    end

    context 'when line is partially outside image bounds' do
      it 'sets appropriate pixels to the given color' do
        expect {
          bitmap_manager.draw_vertical_line(2, 3, 10, 'W')
        }.to change {
          bitmap_manager.show_image
        }.from(
          <<~PIXELS
            OOOOO
            OOOOO
            OOOOO
            OOOOO
            OOOOO
            OOOOO
          PIXELS
        ).to(
          <<~PIXELS
            OOOOO
            OOOOO
            OWOOO
            OWOOO
            OWOOO
            OWOOO
          PIXELS
        )
      end
    end

    context 'when line is completely outside image bounds' do
      it 'sets appropriate pixels to the given color' do
        expect {
          bitmap_manager.draw_vertical_line(7, 6, 10, 'W')
        }.not_to change { bitmap_manager.show_image }
      end
    end
  end

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
