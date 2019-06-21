# frozen_string_literal: true

require 'bitmap_manager'

RSpec.describe BitmapManager do
  let(:bitmap_manager) { described_class.new }

  describe 'clear_image' do
    context 'when current_image is NOT present' do
      subject { bitmap_manager.clear_image }

      it 'raises a BitmapManager::NoImageError' do
        expect { subject }.to raise_error(BitmapManager::NoImageError)
      end
    end

    context 'when current_image is present' do
      subject { bitmap_manager.clear_image }

      let(:bitmap_image) { BitmapImage.new(2, 2) }

      before do
        allow(bitmap_manager).to receive(:current_image)
          .and_return(bitmap_image)
      end

      it 'delegates "clear" instruction to the current_image' do
        expect(bitmap_image).to receive(:clear)
        subject
      end

      it { is_expected.to be_nil }
    end
  end

  describe 'draw_horizontal_line' do
    context 'when current_image is NOT present' do
      subject { bitmap_manager.draw_horizontal_line(3, 5, 2, 'Z') }

      it 'raises a BitmapManager::NoImageError' do
        expect { subject }.to raise_error(BitmapManager::NoImageError)
      end
    end

    context 'when current_image is present' do
      before do
        bitmap_manager.new_image(5, 6)
      end

      context 'when line is fully within image bounds' do
        subject { bitmap_manager.draw_horizontal_line(3, 5, 2, 'Z') }

        it 'sets appropriate pixels to the given color' do
          expect { subject }.to change {
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

        it { is_expected.to be_nil }
      end

      context 'when line is partially outside image bounds' do
        subject { bitmap_manager.draw_horizontal_line(3, 7, 2, 'Z') }

        it 'sets appropriate pixels to the given color' do
          expect { subject }.to change {
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

        it { is_expected.to be_nil }
      end

      context 'when line is completely outside image bounds' do
        subject { bitmap_manager.draw_horizontal_line(6, 9, 2, 'Z') }

        it 'sets appropriate pixels to the given color' do
          expect { subject }.not_to(change { bitmap_manager.show_image })
        end

        it { is_expected.to be_nil }
      end
    end
  end

  describe 'draw_single_pixel' do
    context 'when current_image is NOT present' do
      subject { bitmap_manager.draw_single_pixel(2, 5, 'B') }

      it 'raises a BitmapManager::NoImageError' do
        expect { subject }.to raise_error(BitmapManager::NoImageError)
      end
    end

    context 'when current_image is present' do
      before do
        bitmap_manager.new_image(4, 4)
      end

      context 'when position is outside of image bounds' do
        subject { bitmap_manager.draw_single_pixel(2, 5, 'B') }

        it 'has no effect on the current_image' do
          expect { subject }.not_to(change { bitmap_manager.show_image })
        end

        it { is_expected.to be_nil }
      end

      context 'when position is within image bounds' do
        subject { bitmap_manager.draw_single_pixel(2, 3, 'B') }

        it 'sets a specified pixel of the current_image to the given color' do
          expect { subject }.to change {
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

        it { is_expected.to be_nil }
      end
    end
  end

  describe 'draw_vertical_line' do
    context 'when current_image is NOT present' do
      subject { bitmap_manager.draw_vertical_line(2, 3, 6, 'W') }

      it 'raises a BitmapManager::NoImageError' do
        expect { subject }.to raise_error(BitmapManager::NoImageError)
      end
    end

    context 'when current_image is present' do
      before do
        bitmap_manager.new_image(5, 6)
      end

      context 'when line is fully within image bounds' do
        subject { bitmap_manager.draw_vertical_line(2, 3, 6, 'W') }

        it 'sets appropriate pixels to the given color' do
          expect { subject }.to change {
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

        it { is_expected.to be_nil }
      end

      context 'when line is partially outside image bounds' do
        subject { bitmap_manager.draw_vertical_line(2, 3, 10, 'W') }

        it 'sets appropriate pixels to the given color' do
          expect { subject }.to change {
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

        it { is_expected.to be_nil }
      end

      context 'when line is completely outside image bounds' do
        subject { bitmap_manager.draw_vertical_line(7, 6, 10, 'W') }

        it 'sets appropriate pixels to the given color' do
          expect { subject }.not_to(change { bitmap_manager.show_image })
        end

        it { is_expected.to be_nil }
      end
    end
  end

  describe 'fill' do
    subject { bitmap_manager.fill(2, 2, 'G') }

    before do
      bitmap_manager.new_image(3, 3)

      bitmap_manager.draw_single_pixel(1, 1, 'B')
      bitmap_manager.draw_single_pixel(1, 2, 'B')
      bitmap_manager.draw_single_pixel(2, 2, 'B')
      bitmap_manager.draw_single_pixel(3, 1, 'B')
    end

    it 'fills pixels of the same color as the initially specified one' do
      expect { subject }.to change {
        bitmap_manager.show_image
      }.from(
        <<~PIXELS
          BOB
          BBO
          OOO
        PIXELS
      ).to(
        <<~PIXELS
          GOB
          GGO
          OOO
        PIXELS
      )
    end
  end

  describe 'new_image' do
    subject { bitmap_manager.new_image(4, 3) }

    it 'instantiates a new current_image of the given proportions' do
      subject
      expect(bitmap_manager.show_image).to eq(
        <<~PIXELS
          OOOO
          OOOO
          OOOO
        PIXELS
      )
    end

    it { is_expected.to be_nil }
  end

  describe 'show_image' do
    subject { bitmap_manager.show_image }

    it 'raises a BitmapManager::NoImageError' do
      expect { subject }.to raise_error(BitmapManager::NoImageError)
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
