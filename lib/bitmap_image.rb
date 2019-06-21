# frozen_string_literal: true

# Manages bitmap pixels
class BitmapImage
  class InvalidColor < StandardError; end

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

  def to_s
    rows.map { |row_pixels| row_pixels.join('') }.join(LINE_END) + LINE_END
  end

  private

  alias initialize_pixels clear

  LINE_END = "\n"

  def ensure_valid_color!(color)
    raise InvalidColor.new('invalid color :(') unless color == color.upcase
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
