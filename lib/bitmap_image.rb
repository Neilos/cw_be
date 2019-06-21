# frozen_string_literal: true

# Manages bitmap pixels
class BitmapImage
  class InvalidColor < StandardError; end

  Pixel = Struct.new(:coords_x, :coords_y, :color)

  def initialize(width, height)
    @height = height
    @width = width

    initialize_pixels
  end

  def clear
    @pixels = Array.new(width * height, 'O')
  end

  def color_at(coords_x, coords_y)
    return if out_of_bounds?(coords_x, coords_y)

    pixels[pizel_number(coords_x, coords_y)]
  end

  def color_pixel(coords_x, coords_y, color)
    ensure_valid_color!(color)

    return if out_of_bounds?(coords_x, coords_y)

    pixels[pizel_number(coords_x, coords_y)] = color
  end

  def out_of_bounds?(coords_x, coords_y)
    coords_x <= 0 ||
      coords_y <= 0 ||
      coords_x > width ||
      coords_y > height
  end

  def positions_adjacent_to(coords_x, coords_y)
    return unless block_given?

    yield coords_x, coords_y - 1
    yield coords_x + 1, coords_y
    yield coords_x, coords_y + 1
    yield coords_x - 1, coords_y
  end

  def to_s
    rows.map { |row_pixels| row_pixels.join('') }.join(LINE_END) + LINE_END
  end

  private

  alias initialize_pixels clear

  LINE_END = "\n"

  def ensure_valid_color!(color)
    raise InvalidColor, 'invalid color :(' if
      color != color.upcase || color.length > 1
  end

  def get_pixel(coords_x, coords_y)
    Pixel.new(coords_x, coords_y, color_at(coords_x, coords_y))
  end

  def pizel_number(coords_x, coords_y)
    zero_indexed_x = coords_x - 1
    zero_indexed_y = coords_y - 1
    (width * zero_indexed_y) + zero_indexed_x
  end

  def rows
    pixels.each_slice(width)
  end

  attr_reader :width, :height
  attr_accessor :pixels
end
