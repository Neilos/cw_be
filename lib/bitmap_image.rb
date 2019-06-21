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

  def fill(coords_x, coords_y, color)
    ensure_valid_color!(color)

    return if out_of_bounds?(coords_x, coords_y)

    pixels[pizel_number(coords_x, coords_y)] = color
  end

  def flood_fill(coords_x, coords_y, fill_color, target_color = nil)
    return if out_of_bounds?(coords_x, coords_y)

    pixel = get_pixel(coords_x, coords_y)

    if pixel.color == target_color || target_color.nil?
      fill(coords_x, coords_y, fill_color)

      adjacent_pixels(coords_x, coords_y).each do |adjacent_pixel|
        flood_fill(
          adjacent_pixel.coords_x,
          adjacent_pixel.coords_y,
          fill_color,
          pixel.color,
        )
      end
    end
  end

  def to_s
    rows.map { |row_pixels| row_pixels.join('') }.join(LINE_END) + LINE_END
  end

  private

  alias initialize_pixels clear

  LINE_END = "\n"

  def adjacent_pixels(coords_x, coords_y)
    [
      get_pixel(coords_x, coords_y - 1),
      get_pixel(coords_x + 1, coords_y),
      get_pixel(coords_x, coords_y + 1),
      get_pixel(coords_x - 1, coords_y),
    ]
  end

  def ensure_valid_color!(color)
    raise InvalidColor.new('invalid color :(') unless color == color.upcase
  end

  def get_pixel(coords_x, coords_y)
    Pixel.new(coords_x, coords_y, color_at(coords_x, coords_y))
  end

  def out_of_bounds?(coords_x, coords_y)
    coords_x <= 0 ||
    coords_y <= 0 ||
    coords_x > width ||
    coords_y > height
  end

  def color_at(coords_x, coords_y)
    pixels[pizel_number(coords_x, coords_y)]
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
