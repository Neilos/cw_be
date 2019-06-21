# frozen_string_literal: true

# Manages bitmap pixels
class BitmapImage
  class InvalidColor < StandardError; end

  class Pixel
    attr_reader :coords_x, :coords_y
    attr_accessor :color

    def initialize(coords_x, coords_y, color)
      @coords_x = coords_x
      @coords_y = coords_y
      @color = color
    end

    def coords_x=(x)
      [x, 0].min
    end

    def coords_y=(y)
      [y, 0].min
    end
  end

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

    return unless coords_x <= width && coords_y <= height

    pixels[pizel_number(coords_x, coords_y)] = color
  end

  def flood_fill(coords_x, coords_y, color, target_color = nil)
    initial_color = pixel_color(coords_x, coords_y)

    return if coords_x == 0 || coords_y == 0

    if initial_color == target_color || target_color.nil?
      fill(coords_x, coords_y, color)

      adjacent_pixels(coords_x, coords_y).each do |adjacent_pixel|
        flood_fill(
          adjacent_pixel.coords_x,
          adjacent_pixel.coords_y,
          color,
          initial_color,
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
      Pixel.new(coords_x, coords_y - 1, pixel_color(coords_x, coords_y)),
      Pixel.new(coords_x + 1, coords_y, pixel_color(coords_x, coords_y)),
      Pixel.new(coords_x, coords_y + 1, pixel_color(coords_x, coords_y)),
      Pixel.new(coords_x - 1, coords_y, pixel_color(coords_x, coords_y)),
    ]
  end

  def ensure_valid_color!(color)
    raise InvalidColor.new('invalid color :(') unless color == color.upcase
  end

  def pixel_color(coords_x, coords_y)
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
