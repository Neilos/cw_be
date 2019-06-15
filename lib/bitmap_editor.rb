# frozen_string_literal: true

class BitmapEditor
  attr_accessor :current_image

  def run(file)
    return puts "please provide correct file" if file.nil? || !File.exists?(file)

    File.open(file).each do |line|
      line = line.chomp
      case line
      when 'I'
        puts "new image"
      when 'C'
        puts "clearing image"
      when 'L'
        puts "drawing single pixel"
      when 'V'
        puts "drawing vertical line"
      when 'H'
        puts "drawing horizontal line"
      when 'S'
        puts "There is no image"
      else
      end
    end
  end
end
