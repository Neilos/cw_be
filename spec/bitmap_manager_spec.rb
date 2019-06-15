# frozen_string_literal: true

require 'bitmap_manager'

RSpec.describe BitmapManager do
  let(:bitmap_manager) { described_class.new }

  describe 'clear_image' do
    context 'when current_image is NOT present' do
      it 'does nothing (without complaining)' do
        expect { bitmap_manager.clear_image }.not_to raise_error
      end
    end

    context 'when current_image is present' do
      let(:bitmap_image) { BitmapImage.new(2, 2) }

      before do
        allow(bitmap_manager).to receive(:current_image)
          .and_return(bitmap_image)
      end

      it 'delegates "clear" instruction to the current_image' do
        expect(bitmap_image).to receive(:clear)
        bitmap_manager.clear_image
      end
    end
  end

  describe 'draw_horizontal_line' do
    context 'when current_image is NOT present' do
      it 'does nothing (without complaining)' do
        expect {
          bitmap_manager.draw_horizontal_line(3, 5, 2, 'Z')
        }.not_to raise_error
      end
    end

    context 'when current_image is present' do
      before do
        bitmap_manager.new_image(5, 6)
      end

      context 'when line is fully within image bounds' do
        it 'sets appropriate pixels to the given color' do
          expect {
            bitmap_manager.draw_horizontal_line(3, 5, 2, 'Z')
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
              OOZZZ
              OOOOO
              OOOOO
              OOOOO
              OOOOO
            PIXELS
          )
        end
      end

      context 'when line is partially outside image bounds' do
        it 'sets appropriate pixels to the given color' do
          expect {
            bitmap_manager.draw_horizontal_line(3, 7, 2, 'Z')
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
              OOZZZ
              OOOOO
              OOOOO
              OOOOO
              OOOOO
            PIXELS
          )
        end
      end

      context 'when line is completely outside image bounds' do
        it 'sets appropriate pixels to the given color' do
          expect {
            bitmap_manager.draw_horizontal_line(6, 9, 2, 'Z')
          }.not_to change { bitmap_manager.show_image }
        end
      end
    end
  end

  describe 'draw_single_pixel' do
    context 'when current_image is NOT present' do
      it 'does nothing (without complaining)' do
        expect {
          bitmap_manager.draw_single_pixel(2, 5, 'B')
        }.not_to raise_error
      end
    end

    context 'when current_image is present' do
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
  end

  describe 'draw_vertical_line' do
    context 'when current_image is NOT present' do
      it 'does nothing (without complaining)' do
        expect {
          bitmap_manager.draw_vertical_line(2, 3, 6, 'W')
        }.not_to raise_error
      end
    end

    context 'when current_image is present' do
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
