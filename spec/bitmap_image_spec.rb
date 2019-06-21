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
      bitmap.fill(2, 2, 'F')
      bitmap.fill(3, 3, 'A')
      bitmap.fill(4, 4, 'C')
      bitmap.fill(5, 5, 'E')
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

  describe '#fill' do
    context 'when valid color' do
      context 'when position is within image bounds' do
        subject { bitmap.fill(3, 4, 'Y') }

        it 'fills the specified pixel with the given color' do
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
        subject { bitmap.fill(3, 4, 'y') }

        it 'is expected to raise an InvalidColor error' do
          expect { subject }.to raise_error(BitmapImage::InvalidColor)
        end
      end
    end

    context 'when position is beyond image right edge' do
      subject { bitmap.fill(6, 4, 'Y') }

      it 'does nothing' do
        expect { subject }.not_to(change { bitmap.to_s })
      end
    end

    context 'when position is beyond image bottom edge' do
      subject { bitmap.fill(3, 7, 'Y') }

      it 'does nothing' do
        expect { subject }.not_to(change { bitmap.to_s })
      end
    end

    context 'when position is beyond image left edge' do
      subject { bitmap.fill(-1, 4, 'Y') }

      it 'does nothing' do
        expect { subject }.not_to(change { bitmap.to_s })
      end
    end

    context 'when position is beyond image top edge' do
      subject { bitmap.fill(3, -1, 'Y') }

      it 'does nothing' do
        expect { subject }.not_to(change { bitmap.to_s })
      end
    end
  end

  describe 'flood_fill' do
    subject { bitmap.flood_fill(2, 2, 'G') }

    let(:width) { 3 }
    let(:height) { 3 }

    before do
      bitmap.fill(1, 1, 'B')
      bitmap.fill(1, 2, 'B')
      bitmap.fill(2, 2, 'B')
      bitmap.fill(3, 1, 'B')
    end

    it 'flood fills the image' do
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
