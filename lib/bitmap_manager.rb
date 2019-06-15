# frozen_string_literal: true

require_relative 'bitmap_image'

# Translates commands into transformations understood by the BitmapImage
class BitmapManager
  def show_image
    current_image.to_s
  end

  private

  attr_accessor :current_image
end
