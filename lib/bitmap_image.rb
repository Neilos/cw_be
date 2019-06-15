# frozen_string_literal: true

# Manages bitmap pixels
class BitmapImage
  def initialize(width, height)
    @height = height
    @width = width
    @pixels = Array.new(width * height, 'O')
  end

  def to_s
    rows.map { |row_pixels| row_pixels.join('') }.join(LINE_END) + LINE_END
  end

  private

  LINE_END = "\n"

  def rows
    pixels.each_slice(width)
  end

  attr_reader :width, :height, :pixels
end
