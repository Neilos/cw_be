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

  describe 'color_at' do
    context 'when within bounds' do
      subject { bitmap.color_at(0, 4) }

      it { is_expected.to be_nil }
    end

    context 'when out of bounds' do
      subject { bitmap.color_at(3, 4) }

      before do
        bitmap.color_pixel(3, 4, 'Y')
      end

      it 'is the right color' do
        expect(subject).to eq('Y')
      end
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

      context 'when multiple character color' do
        subject { bitmap.color_pixel(3, 4, 'AG') }

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

  describe 'out_of_bounds?' do
    context 'when position is within bounds' do
      subject { bitmap.out_of_bounds?(5, 6) }

      it { is_expected.to eq(false) }
    end

    context 'when position is beyond image right edge' do
      subject { bitmap.out_of_bounds?(6, 4) }

      it { is_expected.to eq(true) }
    end

    context 'when position is beyond image bottom edge' do
      subject { bitmap.out_of_bounds?(3, 7) }

      it { is_expected.to eq(true) }
    end

    context 'when position is beyond image left edge' do
      subject { bitmap.out_of_bounds?(-1, 4) }

      it { is_expected.to eq(true) }
    end

    context 'when position is beyond image top edge' do
      subject { bitmap.out_of_bounds?(3, -1) }

      it { is_expected.to eq(true) }
    end
  end

  describe 'positions_adjacent_to' do
    let(:coords_x) { 3 }
    let(:coords_y) { 2 }

    it 'the four adjacent positions in turn' do
      expect { |blk|
        bitmap.positions_adjacent_to(coords_x, coords_y, &blk)
      }.to yield_successive_args(
        [3, 1],
        [4, 2],
        [3, 3],
        [2, 2],
      )
    end
  end
end
