# frozen_string_literal: true

require_relative 'bitmap_image'

# Translates complex commands into simple ones understood by the BitmapImage
class BitmapManager
  class NoImageError < RuntimeError; end

  def clear_image
    ensure_current_image!
    current_image.clear
    nil
  end

  def draw_single_pixel(coords_x, coords_y, color)
    ensure_current_image!
    current_image.color_pixel(coords_x, coords_y, color)
    nil
  end

  def draw_horizontal_line(coords_x1, coords_x2, coords_y, color)
    ensure_current_image!

    (coords_x1..coords_x2).each do |coords_x|
      current_image.color_pixel(coords_x, coords_y, color)
    end

    nil
  end

  def draw_vertical_line(coords_x, coords_y1, coords_y2, color)
    ensure_current_image!

    (coords_y1..coords_y2).each do |coords_y|
      current_image.color_pixel(coords_x, coords_y, color)
    end

    nil
  end

  def new_image(width, height)
    self.current_image = BitmapImage.new(width, height)
    nil
  end

  def show_image
    ensure_current_image!
    current_image.to_s
  end

  private

  attr_accessor :current_image

  def ensure_current_image!
    raise BitmapManager::NoImageError unless current_image
  end
end
