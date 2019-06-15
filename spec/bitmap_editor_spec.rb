require 'bitmap_editor'

RSpec.describe BitmapEditor do
  let(:bitmap_editor) { described_class.new }

  describe 'current_image' do
    subject { bitmap_editor.current_image }

    context 'prior to any commands' do
      it { is_expected.to be_nil }
    end

    context 'after it is set' do
      it 'returns a bitmap' do
        bitmap_editor.current_image = 'something for for'
        expect(subject).not_to be_nil
      end
    end
  end

  describe 'run'
end
