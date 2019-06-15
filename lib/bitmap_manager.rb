# frozen_string_literal: true

require_relative 'bitmap_image'

# Translates commands into transformations understood by the BitmapImage
class BitmapManager
  def draw_single_pixel(coords_x, coords_y, color)
    current_image.fill(coords_x, coords_y, color)
  end

  def draw_vertical_line(coords_x, coords_y1, coords_y2, color)
    (coords_y1..coords_y2).each do |coords_y|
      current_image.fill(coords_x, coords_y, color)
    end
  end

  def new_image(width, height)
    self.current_image = BitmapImage.new(width, height)
  end

  def show_image
    current_image.to_s
  end

  private

  attr_accessor :current_image
end
