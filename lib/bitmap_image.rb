# frozen_string_literal: true

# Manages bitmap pixels
class BitmapImage
  def initialize(width, height)
    @height = height
    @width = width
    @pixels = Array.new(width * height, 'O')
  end

  def fill(coords_x, coords_y, color)
    return unless coords_x <= width && coords_y <= height

    pixels[pizel_number(coords_x, coords_y)] = color
  end

  def to_s
    rows.map { |row_pixels| row_pixels.join('') }.join(LINE_END) + LINE_END
  end

  private

  LINE_END = "\n"

  def pizel_number(coords_x, coords_y)
    zero_indexed_x = coords_x - 1
    zero_indexed_y = coords_y - 1
    (width * zero_indexed_y) + zero_indexed_x
  end

  def rows
    pixels.each_slice(width)
  end

  attr_reader :width, :height, :pixels
end
