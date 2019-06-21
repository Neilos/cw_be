# frozen_string_literal: true

require 'bitmap_image'

RSpec.describe BitmapImage do
  let(:width) { 5 }
  let(:height) { 6 }
  let(:bitmap) { described_class.new(width, height) }

  describe '#to_s' do
    it 'is a string representation of the bitmap' do
      expect(bitmap.to_s).to eq <<~PIXELS
        OOOOO
        OOOOO
        OOOOO
        OOOOO
        OOOOO
        OOOOO
      PIXELS
    end
  end

  describe '#clear' do
    subject { bitmap.clear }

    before do
      # Fill some pixels with color
      bitmap.color_pixel(2, 2, 'F')
      bitmap.color_pixel(3, 3, 'A')
      bitmap.color_pixel(4, 4, 'C')
      bitmap.color_pixel(5, 5, 'E')
    end

    it 'resets all the pixels to their original "O" color' do
      expect { subject }.to change {
        bitmap.to_s
      }.from(
        <<~PIXELS
          OOOOO
          OFOOO
          OOAOO
          OOOCO
          OOOOE
          OOOOO
        PIXELS
      ).to(
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

  describe '#color_pixel' do
    context 'when valid color' do
      context 'when position is within image bounds' do
        subject { bitmap.color_pixel(3, 4, 'Y') }

        it 'color_pixels the specified pixel with the given color' do
          expect { subject }.to change {
            bitmap.to_s
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
              OOOOO
              OOYOO
              OOOOO
              OOOOO
            PIXELS
          )
        end
      end

      context 'when lowercase color' do
        subject { bitmap.color_pixel(3, 4, 'y') }

        it 'is expected to raise an InvalidColor error' do
          expect { subject }.to raise_error(BitmapImage::InvalidColor)
        end
      end
    end

    context 'when position is beyond image right edge' do
      subject { bitmap.color_pixel(6, 4, 'Y') }

      it 'does nothing' do
        expect { subject }.not_to(change { bitmap.to_s })
      end
    end

    context 'when position is beyond image bottom edge' do
      subject { bitmap.color_pixel(3, 7, 'Y') }

      it 'does nothing' do
        expect { subject }.not_to(change { bitmap.to_s })
      end
    end

    context 'when position is beyond image left edge' do
      subject { bitmap.color_pixel(-1, 4, 'Y') }

      it 'does nothing' do
        expect { subject }.not_to(change { bitmap.to_s })
      end
    end

    context 'when position is beyond image top edge' do
      subject { bitmap.color_pixel(3, -1, 'Y') }

      it 'does nothing' do
        expect { subject }.not_to(change { bitmap.to_s })
      end
    end
  end

  describe 'fill' do
    subject { bitmap.fill(2, 2, 'G') }

    let(:width) { 3 }
    let(:height) { 3 }

    before do
      bitmap.color_pixel(1, 1, 'B')
      bitmap.color_pixel(1, 2, 'B')
      bitmap.color_pixel(2, 2, 'B')
      bitmap.color_pixel(3, 1, 'B')
    end

    it 'fills pixels of the same color as the initially specified one' do
      expect { subject }.to change {
        bitmap.to_s
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
end
