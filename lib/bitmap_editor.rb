# frozen_string_literal: true

require_relative 'bitmap_manager'
require_relative 'command_parser'

# When `run`, it opens a given file,
# parsing commands line by line,
# delegating recognised commands to the BitmapManager
class BitmapEditor
  def initialize(bitmap_manager = BitmapManager.new)
    @bitmap_manager = bitmap_manager
  end

  def run(file, &block)
    File.foreach(file).each do |line|
      execute_command(line, &block)
    end
  end

  private

  attr_reader :bitmap_manager

  def execute_command(line)
    yield bitmap_manager.send(*CommandParser.new.parse(line)) if block_given?
  rescue BitmapManager::NoImageError
    yield 'There is no image'
  rescue BitmapImage::InvalidColor
    yield 'invalid color :('
  rescue CommandParser::UnrecognizedError
    yield 'unrecognised command :('
  end
end
