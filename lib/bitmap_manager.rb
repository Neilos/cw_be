# frozen_string_literal: true

require_relative 'bitmap_image'

# Translates commands into transformations understood by the BitmapImage
class BitmapManager
  def clear_image
    current_image&.clear
  end

  def draw_single_pixel(coords_x, coords_y, color)
    current_image&.fill(coords_x, coords_y, color)
  end

  def draw_horizontal_line(coords_x1, coords_x2, coords_y, color)
    return unless current_image

    (coords_x1..coords_x2).each do |coords_x|
      current_image.fill(coords_x, coords_y, color)
    end
  end

  def draw_vertical_line(coords_x, coords_y1, coords_y2, color)
    return unless current_image

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
