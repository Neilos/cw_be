# frozen_string_literal: true

require 'bitmap_manager'

RSpec.describe BitmapManager do
  let(:bitmap_manager) { described_class.new }

  describe 'show_image' do
    subject { bitmap_manager.show_image }

    context 'when no current_image (by default)' do
      it { is_expected.to eq '' }
    end

    context 'when current_image is set' do
      let(:bitmap_image) { BitmapImage.new(3, 4) }

      before do
        # Stub private current_image value
        allow(bitmap_manager).to receive(:current_image)
          .and_return(bitmap_image)
      end

      it 'returns the to_s representation of the current_image' do
        expect(subject).to eq(<<~PIXELS
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
